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
    return window.location.hash.replace(/^#\/?/, '') || 'about';
  }

  function updateRoute() {
    route = getRoute();
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  onMount(() => {
    window.addEventListener('hashchange', updateRoute);
    updateRoute();

    return () => window.removeEventListener('hashchange', updateRoute);
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
    {#if Page}
      <svelte:component this={Page} />
    {:else}
      <section class="page-section">
        <h1>Page not found</h1>
        <p>The page you requested does not exist.</p>
        <a href="/">Return to the home page</a>
      </section>
    {/if}
  </main>
</div>
