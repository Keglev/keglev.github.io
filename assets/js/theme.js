/*
  assets/js/theme.js
  ==================
  The only JavaScript on this site. It does one thing: switch the colour
  theme between dark (the default) and light.

  IT DOES NOT HANDLE LANGUAGE SWITCHING.
  English and German are two separately built static pages (/ and /de/)
  and the switch between them is a plain link in the header. Nothing about
  the text on the page is decided at runtime — see _data/i18n.yml.

  SOURCE OF TRUTH
    The `data-theme` attribute on <html>, whose value is "dark" or "light".
    Every colour in main.css is a custom property redefined under
    [data-theme="light"], so no component rule needs to know which theme is
    active and no class has to be toggled anywhere else in the DOM.

  WHO SETS IT FIRST
    Not this file. The inline boot script in _layouts/default.html runs
    before the stylesheet is fetched and applies the stored preference
    immediately, which is what prevents a flash of the wrong theme. This
    file only takes over from the point the user interacts.

  RESOLUTION ORDER
    1. An explicit choice stored in localStorage under the key "theme".
    2. Otherwise the operating system preference, followed live.
    3. Otherwise dark.

  PERSISTENCE IS OPTIONAL
    Safari in private mode throws on localStorage access, so every read and
    write is wrapped in try/catch. Without persistence the toggle still
    works for the current page view; it simply forgets the choice.
*/

(function () {
    'use strict';

    var STORAGE_KEY = 'theme';
    var root = document.documentElement;
    var toggle = document.getElementById('theme-toggle');

    // The toggle only exists in the site header. If a page renders without
    // it there is nothing to wire up.
    if (!toggle) {
        return;
    }

    /* Reads the stored choice. Returns null when nothing valid is stored,
       or when storage is unavailable. */
    function readStored() {
        try {
            var value = localStorage.getItem(STORAGE_KEY);
            return (value === 'light' || value === 'dark') ? value : null;
        } catch (e) {
            return null;
        }
    }

    /* Persists the choice. A failure here is not an error the user needs
       to know about: the theme is already applied either way. */
    function writeStored(value) {
        try {
            localStorage.setItem(STORAGE_KEY, value);
        } catch (e) {
            /* no persistence available */
        }
    }

    function currentTheme() {
        return root.getAttribute('data-theme') === 'light' ? 'light' : 'dark';
    }

    /* Keeps the control in step with the theme.

       aria-checked reports the state (on = light). aria-label is rewritten
       from the two data- attributes the layout renders, so a screen reader
       announces the ACTION that is available ("Switch to light theme")
       rather than repeating the state the user is already in. Both labels
       come from the i18n catalogue, so they are already translated. */
    function syncControl(theme) {
        var isLight = theme === 'light';
        toggle.setAttribute('aria-checked', isLight ? 'true' : 'false');
        toggle.setAttribute(
            'aria-label',
            isLight
                ? toggle.getAttribute('data-label-dark')
                : toggle.getAttribute('data-label-light')
        );
    }

    function applyTheme(theme) {
        root.setAttribute('data-theme', theme);
        syncControl(theme);
    }

    // The boot script has already set the attribute; adopt whatever it
    // decided so the control does not contradict the painted page.
    syncControl(currentTheme());

    toggle.addEventListener('click', function () {
        var next = currentTheme() === 'light' ? 'dark' : 'light';
        applyTheme(next);
        writeStored(next);
    });

    /* Follow the operating system, but only while the user has not made an
       explicit choice. Once something is stored, that choice wins and the
       listener stops having an effect. */
    if (window.matchMedia) {
        var mq = window.matchMedia('(prefers-color-scheme: light)');

        var onSystemChange = function (event) {
            if (readStored() === null) {
                applyTheme(event.matches ? 'light' : 'dark');
            }
        };

        if (typeof mq.addEventListener === 'function') {
            mq.addEventListener('change', onSystemChange);
        } else if (typeof mq.addListener === 'function') {
            // Safari below 14 and older Chromium releases.
            mq.addListener(onSystemChange);
        }
    }
})();
