<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>SkillSwap – Home & Explore</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root {
      --bg: #f4f5ff;
      --card-bg: #ffffff;
      --primary: #6b5bff;
      --primary-soft: #ede9ff;
      --text-main: #1f2933;
      --text-sub: #6b7280;
      --border-soft: #e5e7eb;
      --radius-lg: 20px;
      --radius-xl: 28px;
      --shadow-soft: 0 18px 40px rgba(15, 23, 42, 0.08);
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI",
        sans-serif;
      background: radial-gradient(circle at top, #eef2ff 0, #f9fafb 40%);
      min-height: 100vh;
      display: flex;
      align-items: stretch;
      justify-content: center;
      padding: 24px;
      color: var(--text-main);
    }

    .app-shell {
      max-width: 1200px;
      width: 100%;
      background: var(--card-bg);
      border-radius: var(--radius-xl);
      box-shadow: var(--shadow-soft);
      padding: 22px 26px 20px;
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    /* HEADER */
    .top-bar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 16px;
    }

    .brand-row {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .logo-icon {
      width: 40px;
      height: 40px;
      border-radius: 16px;
      background: linear-gradient(135deg, #6b5bff, #a855f7);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      font-size: 20px;
      font-weight: 700;
    }

    .brand-title {
      font-weight: 800;
      font-size: 22px;
      color: var(--primary);
    }

    .brand-sub {
      font-size: 12px;
      color: var(--text-sub);
    }

    .top-right {
      display: flex;
      align-items: center;
      gap: 14px;
    }

    .notif-wrapper {
      position: relative;
      width: 24px;
      height: 24px;
      border-radius: 999px;
      background: #f3f4ff;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      color: #4b5563;
    }

    .notif-dot {
      position: absolute;
      top: 3px;
      right: 4px;
      width: 7px;
      height: 7px;
      border-radius: 999px;
      background: #ef4444;
      border: 1px solid #fff;
    }

    .avatar {
      width: 32px;
      height: 32px;
      border-radius: 999px;
      background: linear-gradient(135deg, #f97316, #ec4899);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      font-size: 14px;
      font-weight: 700;
    }

    /* TOP NAV – first design (pill on active tab) */
    .nav-row {
      display: flex;
      justify-content: center;
    }

    .nav-tabs {
      display: inline-flex;
      align-items: center;
      gap: 24px;
      font-size: 14px;
      color: #6b7280;
    }

    .nav-tab {
      border: none;
      background: transparent;
      padding: 6px 16px;
      border-radius: 999px;
      cursor: pointer;
      color: inherit;
      font: inherit;
      transition: background 0.15s, color 0.15s, box-shadow 0.15s;
    }

    .nav-tab.active {
      background: #f3edff;      /* light purple pill */
      color: var(--primary);     /* blue/purple text */
      box-shadow: 0 4px 14px rgba(148, 163, 184, 0.55);
      font-weight: 600;
    }

    .nav-tab:hover:not(.active) {
      color: #4b5563;
    }

    /* SCREENS */
    .screen {
      display: none;
    }
    .screen.active {
      display: block;
    }

    /* LAYOUT + CARDS (shared) */
    .layout {
      display: grid;
      grid-template-columns: minmax(0, 380px) minmax(0, 1fr);
      gap: 22px;
      margin-top: 8px;
    }

    .card {
      background: var(--card-bg);
      border-radius: var(--radius-lg);
      border: 1px solid rgba(229, 231, 235, 0.9);
      padding: 16px 18px;
    }

    .stack {
      display: flex;
      flex-direction: column;
      gap: 14px;
    }

    .section-header {
      display: flex;
      align-items: baseline;
      justify-content: space-between;
      margin-bottom: 8px;
    }

    .section-header h2 {
      font-size: 16px;
      font-weight: 700;
    }

    .section-header a {
      font-size: 12px;
      color: var(--primary);
      text-decoration: none;
      font-weight: 500;
    }

    .section-title {
      font-size: 16px;
      font-weight: 700;
      margin-bottom: 12px;
    }

    .search-bar {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 10px 14px;
      border-radius: 999px;
      border: 1px solid var(--border-soft);
      background: #f9fafb;
      font-size: 13px;
      color: var(--text-sub);
    }

    .search-bar input {
      border: none;
      outline: none;
      background: transparent;
      width: 100%;
      font-size: 13px;
    }

    /* HOME SCREEN (first design) */
    .hero-card {
      padding: 24px 22px;
      background: radial-gradient(circle at top, #f5f3ff 0, #ffffff 60%);
    }

    .hero-icon {
      width: 64px;
      height: 64px;
      border-radius: 24px;
      background: linear-gradient(135deg, #6b5bff, #a855f7);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 28px;
      margin-bottom: 18px;
    }

    .hero-title {
      font-size: 26px;
      font-weight: 800;
      margin-bottom: 4px;
    }

    .hero-tagline {
      font-size: 13px;
      color: var(--text-sub);
      margin-bottom: 20px;
    }

    .hero-list {
      display: flex;
      flex-direction: column;
      gap: 10px;
      margin-bottom: 20px;
    }

    .hero-list-item {
      display: grid;
      grid-template-columns: auto minmax(0, 1fr);
      gap: 10px;
      align-items: flex-start;
    }

    .hero-pill-icon {
      width: 32px;
      height: 32px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 16px;
      color: white;
    }
    .hero-pill-icon.learn { background: #38bdf8; }
    .hero-pill-icon.share { background: #a855f7; }
    .hero-pill-icon.safe  { background: #22c55e; }

    .hero-item-title {
      font-size: 14px;
      font-weight: 600;
    }

    .hero-item-text {
      font-size: 12px;
      color: var(--text-sub);
    }

    .hero-cta {
      margin-top: 8px;
      margin-bottom: 8px;
    }

    .hero-cta button {
      border-radius: 999px;
      border: none;
      padding: 10px 22px;
      width: 100%;
      background: var(--primary);
      color: white;
      font-weight: 600;
      font-size: 15px;
      cursor: pointer;
      box-shadow: 0 14px 30px rgba(107, 91, 255, 0.4);
    }

    .hero-legal {
      font-size: 11px;
      color: var(--text-sub);
      margin-top: 4px;
    }

    .welcome-card {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 14px;
    }

    .welcome-user {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .welcome-avatar {
      width: 40px;
      height: 40px;
      border-radius: 999px;
      background: linear-gradient(135deg, #f97316, #fb7185);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      font-weight: 700;
      font-size: 16px;
    }

    .welcome-meta span {
      display: block;
      font-size: 12px;
      color: var(--text-sub);
    }

    .welcome-meta strong {
      font-size: 14px;
    }

    .welcome-badge {
      background: #fee2e2;
      color: #b91c1c;
      font-size: 11px;
      border-radius: 999px;
      padding: 4px 10px;
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .categories-grid-home {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 10px;
    }

    .category-card-home {
      padding: 12px 12px;
      border-radius: 16px;
      border: 1px solid rgba(229, 231, 235, 0.9);
      background: #f9fafb;
      display: flex;
      flex-direction: column;
      gap: 4px;
    }

    .category-card-home:nth-child(1) { background: #ecf3ff; }
    .category-card-home:nth-child(2) { background: #f3e8ff; }
    .category-card-home:nth-child(3) { background: #e7f7ef; }
    .category-card-home:nth-child(4) { background: #fff1e3; }

    .category-icon-home {
      width: 32px;
      height: 32px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      margin-bottom: 6px;
    }

    .category-title {
      font-size: 13px;
      font-weight: 600;
    }

    .category-sub {
      font-size: 11px;
      color: var(--text-sub);
    }

    .skills-list-home {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .skill-card {
      display: grid;
      grid-template-columns: auto minmax(0, 1fr) auto;
      gap: 12px;
      align-items: center;
      padding: 14px 16px;
      border-radius: 18px;
      border: 1px solid rgba(229, 231, 235, 0.9);
      background: #f9fafb;
    }

    .skill-avatar {
      width: 44px;
      height: 44px;
      border-radius: 999px;
      background: linear-gradient(135deg, #f97316, #ec4899);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      font-weight: 700;
      font-size: 18px;
    }

    .skill-main {
      display: flex;
      flex-direction: column;
      gap: 3px;
      font-size: 12px;
    }

    .skill-title-row {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 13px;
      font-weight: 600;
    }

    .badge-rating {
      font-size: 11px;
      padding: 2px 8px;
      border-radius: 999px;
      background: #fef3c7;
      color: #92400e;
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }

    .skill-meta {
      color: var(--text-sub);
    }

    .skill-tags {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
      margin-top: 4px;
    }

    .pill {
      font-size: 11px;
      padding: 3px 9px;
      border-radius: 999px;
      background: #e5e7eb;
      color: #374151;
    }

    .skill-cta button {
      border-radius: 999px;
      border: none;
      padding: 8px 14px;
      font-size: 12px;
      font-weight: 600;
      cursor: pointer;
      background: #fff;
      color: var(--primary);
      border: 1px solid var(--primary-soft);
      box-shadow: 0 4px 12px rgba(107, 91, 255, 0.15);
    }

    .quick-actions-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 10px;
    }

    .quick-card {
      border-radius: 16px;
      border: 1px dashed #e5e7eb;
      padding: 10px 12px;
      display: flex;
      align-items: center;
      gap: 10px;
      background: #f9fafb;
      font-size: 13px;
      font-weight: 500;
    }

    .quick-icon {
      width: 30px;
      height: 30px;
      border-radius: 999px;
      background: var(--primary-soft);
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--primary);
      font-size: 18px;
    }

    /* EXPLORE SCREEN (second layout) */
    .categories-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 10px;
    }

    .category-card {
      padding: 10px 12px;
      border-radius: 16px;
      border: 1px solid rgba(229, 231, 235, 0.9);
      background: #f9fafb;
      display: flex;
      flex-direction: column;
      gap: 4px;
      font-size: 12px;
    }

    .category-card.tech { background: #f3f0ff; }
    .category-card.arts { background: #fff7ed; }
    .category-card.fit  { background: #ecfdf3; }
    .category-card.lang { background: #fdf2ff; }
    .category-card.cook { background: #fff7ed; }
    .category-card.music{ background: #eff6ff; }

    .cat-pill {
      width: 32px;
      height: 32px;
      border-radius: 12px;
      background: #ffffff88;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 4px;
      font-size: 16px;
    }

    .category-name {
      font-weight: 600;
    }

    .category-meta {
      font-size: 11px;
      color: var(--text-sub);
    }

    .category-link {
      margin-top: 4px;
      font-size: 11px;
      color: var(--primary);
      text-decoration: none;
    }

    .offers-list {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .offer-card {
      border-radius: 18px;
      border: 1px solid rgba(229, 231, 235, 0.9);
      background: #f9fafb;
      padding: 12px 14px;
      display: grid;
      grid-template-columns: auto minmax(0, 1fr) auto;
      gap: 12px;
      align-items: center;
      font-size: 12px;
    }

    .offer-avatar {
      width: 44px;
      height: 44px;
      border-radius: 999px;
      display: flex;
      align-items: center;
      justify-content: center;
      background: linear-gradient(135deg, #f97316, #ec4899);
      color: #fff;
      font-weight: 700;
      font-size: 18px;
    }

    .offer-main {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }

    .offer-top-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
      font-size: 13px;
      font-weight: 600;
    }

    .offer-rating {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      font-size: 12px;
      color: #f59e0b;
    }

    .offer-label {
      color: var(--text-sub);
    }

    .offer-label strong {
      color: var(--text-main);
    }

    .offer-tags {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
      margin-top: 4px;
    }

    .pill-online {
      background: #e0ecff;
      color: #1d4ed8;
    }

    .pill-city {
      background: #d1fae5;
      color: #047857;
    }

    .pill-reviews {
      background: #fef3c7;
      color: #92400e;
    }

    .offer-cta a {
      display: inline-block;
      border-radius: 999px;
      padding: 8px 14px;
      font-size: 12px;
      font-weight: 600;
      text-decoration: none;
      background: #fff;
      color: var(--primary);
      border: 1px solid var(--primary-soft);
      box-shadow: 0 4px 10px rgba(107, 91, 255, 0.15);
    }

    /* SIMPLE PLACEHOLDER LAYOUT FOR OTHER TABS */
    .placeholder-card {
      max-width: 600px;
      margin: 20px auto 0;
      text-align: center;
      font-size: 14px;
      color: var(--text-sub);
    }

    @media (max-width: 960px) {
      body { padding: 12px; }
      .app-shell { padding: 18px 16px 16px; }
      .layout {
        grid-template-columns: minmax(0, 1fr);
      }
      .categories-grid-home {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }
  </style>
</head>
<body>
  <div class="app-shell">
    <!-- HEADER -->
    <header class="top-bar">
      <div class="brand-row">
        <div class="logo-icon">🤝</div>
        <div>
          <div class="brand-title">SkillSwap</div>
          <div class="brand-sub">Trade skills, build community</div>
        </div>
      </div>

      <div class="top-right">
        <div class="notif-wrapper">
          🔔
          <span class="notif-dot"></span>
        </div>
        <div class="avatar">S</div>
      </div>
    </header>

    <!-- NAV (always same spot) -->
    <div class="nav-row">
      <div class="nav-tabs">
        <button class="nav-tab active" data-screen="home-screen">Home</button>
        <button class="nav-tab" data-screen="explore-screen">Explore</button>
        <button class="nav-tab" data-screen="chats-screen">Chats</button>
        <button class="nav-tab" data-screen="swaps-screen">Swaps</button>
        <button class="nav-tab" data-screen="profile-screen">Profile</button>
      </div>
    </div>

    <!-- HOME SCREEN -->
    <section id="home-screen" class="screen active">
      <div class="layout">
        <!-- left -->
        <section class="hero-card card">
          <div class="hero-icon">🤝</div>
          <h1 class="hero-title">SkillSwap</h1>
          <p class="hero-tagline">
            Trade skills with real people, learn faster, and grow your network.
          </p>

          <div class="hero-list">
            <div class="hero-list-item">
              <div class="hero-pill-icon learn">🎓</div>
              <div>
                <div class="hero-item-title">Learn New Skills</div>
                <div class="hero-item-text">
                  Connect with experts in your area of interest.
                </div>
              </div>
            </div>
            <div class="hero-list-item">
              <div class="hero-pill-icon share">📤</div>
              <div>
                <div class="hero-item-title">Share Your Expertise</div>
                <div class="hero-item-text">
                  Teach others and earn through skill exchange.
                </div>
              </div>
            </div>
            <div class="hero-list-item">
              <div class="hero-pill-icon safe">🛡️</div>
              <div>
                <div class="hero-item-title">Safe &amp; Trusted</div>
                <div class="hero-item-text">
                  Verified profiles and transparent community ratings.
                </div>
              </div>
            </div>
          </div>

          <div class="hero-cta">
            <button>Get Started</button>
          </div>
          <p class="hero-legal">
            By continuing, you agree to our <strong>Terms</strong> &amp;
            <strong>Privacy Policy</strong>.
          </p>
        </section>

        <!-- right -->
        <main class="stack">
          <section class="welcome-card card">
            <div class="welcome-user">
              <div class="welcome-avatar">S</div>
              <div class="welcome-meta">
                <span>Hello, Sarah!</span>
                <strong>Ready to learn something new?</strong>
              </div>
            </div>
            <div class="welcome-badge">🔔 3 new matches</div>
          </section>

          <section class="card" style="padding:10px 14px;">
            <div class="search-bar">
              <span>🔍</span>
              <input type="text" placeholder="Search skills, services, or people..." />
            </div>
          </section>

          <section class="card">
            <div class="section-header">
              <h2>Browse Categories</h2>
            </div>

            <div class="categories-grid-home">
              <article class="category-card-home">
                <div class="category-icon-home">💻</div>
                <div class="category-title">Tech &amp; Programming</div>
                <div class="category-sub">432 skills available</div>
              </article>

              <article class="category-card-home">
                <div class="category-icon-home">🎨</div>
                <div class="category-title">Design &amp; Creative</div>
                <div class="category-sub">298 skills available</div>
              </article>

              <article class="category-card-home">
                <div class="category-icon-home">💪</div>
                <div class="category-title">Health &amp; Fitness</div>
                <div class="category-sub">188 skills available</div>
              </article>

              <article class="category-card-home">
                <div class="category-icon-home">🌐</div>
                <div class="category-title">Languages</div>
                <div class="category-sub">134 skills available</div>
              </article>
            </div>
          </section>

          <section class="card">
            <div class="section-header">
              <h2>Featured Skills</h2>
              <!-- this will also jump to Explore -->
              <a href="#" data-screen="explore-screen">View All</a>
            </div>

            <div class="skills-list-home">
              <article class="skill-card">
                <div class="skill-avatar">A</div>
                <div class="skill-main">
                  <div class="skill-title-row">
                    <span>Photography Basics</span>
                    <span class="badge-rating">⭐ 4.9</span>
                  </div>
                  <div class="skill-meta">by Alex Chen · Verified Expert</div>
                  <div class="skill-meta">
                    Learn DSLR photography fundamentals in 3 sessions.
                  </div>
                  <div class="skill-tags">
                    <span class="pill">Trade for: Web Dev</span>
                    <span class="pill">3 spots left</span>
                  </div>
                </div>
                <div class="skill-cta">
                  <button>Connect</button>
                </div>
              </article>

              <article class="skill-card">
                <div class="skill-avatar">M</div>
                <div class="skill-main">
                  <div class="skill-title-row">
                    <span>Spanish Conversation</span>
                    <span class="badge-rating">⭐ 4.8</span>
                  </div>
                  <div class="skill-meta">by Maria Rodriguez · Native Speaker</div>
                  <div class="skill-meta">
                    Improve your speaking skills through weekly practice.
                  </div>
                  <div class="skill-tags">
                    <span class="pill">Trade for: Guitar Lessons</span>
                    <span class="pill">Online &amp; in person</span>
                  </div>
                </div>
                <div class="skill-cta">
                  <button>Connect</button>
                </div>
              </article>
            </div>
          </section>

          <section class="card">
            <div class="section-header">
              <h2>Quick Actions</h2>
            </div>
            <div class="quick-actions-grid">
              <div class="quick-card">
                <div class="quick-icon">＋</div>
                <div>Offer a Skill</div>
              </div>
              <div class="quick-card">
                <div class="quick-icon">🔍</div>
                <div>Find Skills</div>
              </div>
            </div>
          </section>
        </main>
      </div>
    </section>

    <!-- EXPLORE SCREEN -->
    <section id="explore-screen" class="screen">
      <div class="layout">
        <!-- left -->
        <section>
          <div class="card" style="margin-bottom:10px;">
            <div class="search-bar">
              <span>🔍</span>
              <input type="text" placeholder="What do you want to learn?" />
              <span>🎙️</span>
            </div>
          </div>

          <div class="card">
            <h2 class="section-title">Browse Categories</h2>
            <div class="categories-grid">
              <article class="category-card tech">
                <div class="cat-pill">💻</div>
                <div class="category-name">Tech</div>
                <div class="category-meta">240+ skills</div>
                <a href="#" class="category-link">View skills →</a>
              </article>

              <article class="category-card arts">
                <div class="cat-pill">🎭</div>
                <div class="category-name">Arts</div>
                <div class="category-meta">180+ skills</div>
                <a href="#" class="category-link">View skills →</a>
              </article>

              <article class="category-card fit">
                <div class="cat-pill">💪</div>
                <div class="category-name">Fitness</div>
                <div class="category-meta">95+ skills</div>
                <a href="#" class="category-link">View skills →</a>
              </article>

              <article class="category-card lang">
                <div class="cat-pill">🌐</div>
                <div class="category-name">Languages</div>
                <div class="category-meta">50+ skills</div>
                <a href="#" class="category-link">View skills →</a>
              </article>

              <article class="category-card cook">
                <div class="cat-pill">🍳</div>
                <div class="category-name">Cooking</div>
                <div class="category-meta">120+ skills</div>
                <a href="#" class="category-link">View skills →</a>
              </article>

              <article class="category-card music">
                <div class="cat-pill">🎵</div>
                <div class="category-name">Music</div>
                <div class="category-meta">85+ skills</div>
                <a href="#" class="category-link">View skills →</a>
              </article>
            </div>
          </div>
        </section>

        <!-- right -->
        <main class="card">
          <div class="section-header">
            <h2 class="section-title" style="margin-bottom:0;">Featured Offers</h2>
            <a href="#">See all</a>
          </div>

          <div class="offers-list">
            <article class="offer-card">
              <div class="offer-avatar">A</div>
              <div class="offer-main">
                <div class="offer-top-row">
                  <span>Alex Chen</span>
                  <span class="offer-rating">⭐ 4.9</span>
                </div>
                <div class="offer-label">
                  Teaching: <strong>React Development</strong>
                </div>
                <div class="offer-label">
                  Looking for: <strong>Spanish Lessons</strong>
                </div>
                <div class="offer-tags">
                  <span class="pill pill-online">🟢 Online</span>
                  <span class="pill">Available now</span>
                </div>
              </div>
              <div class="offer-cta">
                <a href="#">Connect</a>
              </div>
            </article>

            <article class="offer-card">
              <div class="offer-avatar">S</div>
              <div class="offer-main">
                <div class="offer-top-row">
                  <span>Sarah Miller</span>
                  <span class="offer-rating">⭐ 4.8</span>
                </div>
                <div class="offer-label">
                  Teaching: <strong>Photography</strong>
                </div>
                <div class="offer-label">
                  Looking for: <strong>Guitar Lessons</strong>
                </div>
                <div class="offer-tags">
                  <span class="pill pill-city">📍 NYC</span>
                  <span class="pill pill-reviews">3 reviews</span>
                </div>
              </div>
              <div class="offer-cta">
                <a href="#">Connect</a>
              </div>
            </article>

            <article class="offer-card">
              <div class="offer-avatar">M</div>
              <div class="offer-main">
                <div class="offer-top-row">
                  <span>Marcus Johnson</span>
                  <span class="offer-rating">⭐ 5.0</span>
                </div>
                <div class="offer-label">
                  Teaching: <strong>Fitness Training</strong>
                </div>
                <div class="offer-label">
                  Looking for: <strong>Web Design</strong>
                </div>
                <div class="offer-tags">
                  <span class="pill pill-city">📍 LA</span>
                  <span class="pill pill-reviews">15 reviews</span>
                </div>
              </div>
              <div class="offer-cta">
                <a href="#">Connect</a>
              </div>
            </article>

            <article class="offer-card">
              <div class="offer-avatar">E</div>
              <div class="offer-main">
                <div class="offer-top-row">
                  <span>Emma Wilson</span>
                  <span class="offer-rating">⭐ 4.7</span>
                </div>
                <div class="offer-label">
                  Teaching: <strong>French Language</strong>
                </div>
                <div class="offer-label">
                  Looking for: <strong>Yoga Classes</strong>
                </div>
                <div class="offer-tags">
                  <span class="pill pill-online">🟢 Online</span>
                  <span class="pill pill-reviews">8 reviews</span>
                </div>
              </div>
              <div class="offer-cta">
                <a href="#">Connect</a>
              </div>
            </article>
          </div>
        </main>
      </div>
    </section>

    <!-- CHATS / SWAPS / PROFILE (placeholders, same shell & size) -->
    <section id="chats-screen" class="screen">
      <div class="placeholder-card card">
        <h2 style="margin-bottom:8px;">Chats</h2>
        <p>Messaging UI will go here. For now this is a placeholder screen.</p>
      </div>
    </section>

    <section id="swaps-screen" class="screen">
      <div class="placeholder-card card">
        <h2 style="margin-bottom:8px;">Swaps</h2>
        <p>Track active and completed skill swaps on this page.</p>
      </div>
    </section>

    <section id="profile-screen" class="screen">
      <div class="placeholder-card card">
        <h2 style="margin-bottom:8px;">Profile</h2>
        <p>Profile details, skills, and preferences will appear here.</p>
      </div>
    </section>
  </div>

  <script>
    // Nav tab switching – keeps nav in place, swaps screens only
    document.addEventListener("DOMContentLoaded", function () {
      const tabs = document.querySelectorAll(".nav-tab");
      const screens = document.querySelectorAll(".screen");

      function showScreen(id) {
        screens.forEach((s) => s.classList.toggle("active", s.id === id));
      }

      tabs.forEach((tab) => {
        tab.addEventListener("click", function () {
          const targetId = this.dataset.screen;
          if (!targetId) return;

          tabs.forEach((t) => t.classList.remove("active"));
          this.classList.add("active");
          showScreen(targetId);
        });
      });

      // "View All" on Home → Explore
      const viewAll = document.querySelector(
        "#home-screen .section-header a[data-screen]"
      );
      if (viewAll) {
        viewAll.addEventListener("click", function (e) {
          e.preventDefault();
          const targetId = this.dataset.screen;
          showScreen(targetId);
          tabs.forEach((t) => t.classList.remove("active"));
          document
            .querySelector('.nav-tab[data-screen="' + targetId + '"]')
            .classList.add("active");
        });
      }
    });
  </script>
</body>
</html>
