<script>
  import { onMount } from 'svelte';
  import Footer from './lib/Footer.svelte';
  import Header from './lib/Header.svelte';
  import Navigation from './lib/Navigation.svelte';
  import About from './pages/About.svelte';
  import News from './pages/News.svelte';
  import People from './pages/People.svelte';
  import Publications from './pages/Publications.svelte';
  import Tools from './pages/Tools.svelte';

  let route = getRoute();

  function getRoute() {
    const hashRoute = window.location.hash.replace(/^#\/?/, '');
    const pathRoute = window.location.pathname.replace(/^\/+|\/+$/g, '');
    return hashRoute || pathRoute || 'about';
  }

  function updateRoute() {
    route = getRoute();
    document.querySelector('.content')?.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function handleNavigation(event) {
    const link = event.target.closest('a');
    if (!link || link.target === '_blank' || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
    if (link.origin !== window.location.origin || link.pathname === window.location.pathname) return;

    event.preventDefault();
    window.history.pushState({}, '', link.href);
    updateRoute();
  }

  onMount(() => {
    window.addEventListener('hashchange', updateRoute);
    window.addEventListener('popstate', updateRoute);
    document.addEventListener('click', handleNavigation);
    updateRoute();

    return () => {
      window.removeEventListener('hashchange', updateRoute);
      window.removeEventListener('popstate', updateRoute);
      document.removeEventListener('click', handleNavigation);
    };
  });

  const pages = { about: About, news: News, people: People, publications: Publications, tools: Tools };
  $: Page = pages[route] || null;
  $: document.title = Page ? `${route === 'about' ? 'Wells Wood Research Group' : route[0].toUpperCase() + route.slice(1)} | Wells Wood Research Group` : 'Page not found | Wells Wood Research Group';
</script>

<svelte:head>
  <meta name="theme-color" content="#343434" />
</svelte:head>

<div class="site-shell">
  <aside class="sidebar">
    <Header />
    <Navigation {route} />
    <Footer />
  </aside>

  <main id="main-content" class="content">
    {#key route}
      <div class="page-transition">
        {#if Page}
          <svelte:component this={Page} />
        {:else}
          <section class="page-section">
            <h1>Page not found</h1>
            <p>The page you requested does not exist.</p>
            <a href="/">Return to the home page</a>
          </section>
        {/if}
      </div>
    {/key}
  </main>
</div>
