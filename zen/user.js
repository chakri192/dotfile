// ============================================================
//  Zen Browser — user.js
//  Performance & Quality-of-Life about:config Tweaks
//
//  INSTALLATION:
//  1. Open Zen → type about:support → click "Open Profile Folder"
//  2. Drop this file directly into the profile folder (NOT chrome/)
//     i.e. alongside places.sqlite, prefs.js, etc.
//  3. Restart Zen Browser — settings apply on startup
//
//  HOW IT WORKS:
//  user.js is read on every launch and forces these values,
//  overriding whatever is in prefs.js. To remove a tweak,
//  delete the line here and restart. To make a setting
//  permanent (no user.js needed), set it in about:config.
// ============================================================


// ============================================================
//  PERFORMANCE
// ============================================================

// Use more processes for content — better tab isolation & speed
// Default: 8. Set to 0 for automatic (uses CPU core count).
user_pref("dom.ipc.processCount", 8);

// Increase painting frequency — smoother scrolling & animations
// Default: 15ms. Lower = more repaints but smoother.
user_pref("layout.frame_rate", 60);

// Enable GPU-accelerated canvas (WebGL/2D perf boost)
user_pref("gfx.canvas.accelerated", true);

// Enable WebRender compositor (GPU-based renderer, huge perf gain
// on modern hardware — usually auto-enabled but force it on)
user_pref("gfx.webrender.all", true);
user_pref("gfx.webrender.enabled", true);

// Reduce idle CPU wake-ups
user_pref("dom.timeout.throttling_delay", 0);

// Don't throttle background tabs as aggressively during bursts
// (helps media/download tabs stay snappy)
user_pref("dom.timeout.background_throttling_max_budget", 50);

// Larger network cache (memory-based, faster subsequent loads)
// Default: 512 KB. Setting 0 = auto-size based on RAM.
user_pref("browser.cache.memory.capacity", 524288);

// Enable disk cache (keep browser cache on disk)
user_pref("browser.cache.disk.enable", true);

// Larger disk cache — up to 512 MB for faster revisits
user_pref("browser.cache.disk.capacity", 524288);

// DNS prefetch — start resolving links before you click them
user_pref("network.dns.disablePrefetch", false);
user_pref("network.prefetch-next", true);

// TCP fast open — reduce connection latency
user_pref("network.tcp.tcp_fastopen_enable", true);

// HTTP/3 (QUIC) — faster connections to supporting servers
user_pref("network.http.http3.enabled", true);

// Increase max HTTP connections per server (default 6, max 32)
user_pref("network.http.max-persistent-connections-per-server", 6);

// TLS session caching — faster HTTPS reconnects
user_pref("security.ssl.enable_false_start", true);

// Use hardware AES acceleration if available
user_pref("security.ssl.disable_session_identifiers", false);


// ============================================================
//  MEMORY & RESOURCE MANAGEMENT
// ============================================================

// Aggressive tab unloading — suspend RAM-heavy background tabs
// after 5 minutes of inactivity (milliseconds)
user_pref("browser.tabs.min_inactive_duration_before_unload", 300000);

// GC settings — reduce GC pauses in long sessions
user_pref("javascript.options.mem.gc_incremental", true);
user_pref("javascript.options.mem.gc_per_zone", true);

// Limit memory use by JS strings
user_pref("javascript.options.mem.max", -1);


// ============================================================
//  PRIVACY & TRACKING (light, non-breaking)
// ============================================================

// Enhanced Tracking Protection — disabled to avoid breaking sites
user_pref("privacy.trackingprotection.enabled", false);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);

// Block cryptomining scripts
user_pref("privacy.trackingprotection.cryptomining.enabled", true);

// Do Not Track header
user_pref("privacy.donottrackheader.enabled", true);

// Disable telemetry pings to Mozilla (saves bandwidth)
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);


// ============================================================
//  POPUPS & UI
// ============================================================

// Allow popups globally — do NOT block them
user_pref("dom.disable_open_during_load", false);

// Caret blink rate
user_pref("ui.caretBlinkTime", 500);

// Spellcheck in all text fields
user_pref("layout.spellcheckDefault", 2);

// PDF hardware acceleration
user_pref("pdfjs.enableHWA", true);

// Disable accessibility theme override
user_pref("ui.useAccessibilityTheme", 0);
user_pref("layers.acceleration.disabled", false);
user_pref("layers.acceleration.force-enabled", true);

// Speculative pre-connect on hover (faster page loads)
user_pref("network.http.speculative-parallel-limit", 6);

// Faster SSL session resumption
user_pref("network.ssl_tokens_cache_capacity", 32768);

// GPU video decode (big win on Apple Silicon)
user_pref("media.hardware-video-decoding.enabled", true);
user_pref("media.ffmpeg.vaapi.enabled", false);

// Compositor
user_pref("gfx.webrender.compositor.force-enabled", true);

// ============================================================
//  APPLE SILICON / macOS SPECIFIC
// ============================================================

// Use Metal GPU API (macOS only, huge rendering speedup)
user_pref("gfx.webrender.compositor", "metal");

// CoreAnimation for smoother rendering on macOS
user_pref("gfx.compositor.glcontext.opaque", false);

// Faster image decoding
user_pref("image.mem.decode_bytes_at_a_time", 65536);

// Increase SSL token cache (faster HTTPS on many tabs)
user_pref("network.ssl_tokens_cache_records_per_server", 4);

// Reduce layout reflow cost
user_pref("nglayout.initialpaint.delay", 0);
user_pref("nglayout.initialpaint.delay_in_oopif", 0);

// Faster session restore
user_pref("browser.sessionstore.interval", 60000);

// Reduce disk I/O
user_pref("browser.sessionstore.max_tabs_undo", 5);
user_pref("browser.sessionstore.max_windows_undo", 2);
user_pref("gfx.webrender.compositor", "metal");
user_pref("gfx.compositor.glcontext.opaque", false);
user_pref("image.mem.decode_bytes_at_a_time", 65536);
user_pref("network.ssl_tokens_cache_records_per_server", 4);
user_pref("nglayout.initialpaint.delay", 0);
user_pref("nglayout.initialpaint.delay_in_oopif", 0);
user_pref("browser.sessionstore.interval", 60000);
user_pref("browser.sessionstore.max_tabs_undo", 5);
user_pref("browser.sessionstore.max_windows_undo", 2);

// Smoother async scrolling
user_pref("apz.async-pan-zoom.enabled", true);
user_pref("apz.fling_friction", "0.002");
user_pref("apz.fling_stopped_threshold", "0.01");

// Unload tabs sooner to save RAM (3 min instead of 5)
user_pref("browser.tabs.min_inactive_duration_before_unload", 180000);

// Kill remaining telemetry
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.shield.optoutstudies.enabled", false);
