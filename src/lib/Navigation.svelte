<script>
  export let route;

  const links = [
    ['about', 'About'],
    ['news', 'News'],
    ['people', 'People'],
    ['publications', 'Publications'],
    ['tools', 'Tools']
  ];
</script>

<nav class="site-nav" aria-label="Main navigation">
  {#each links as [slug, label]}
    <a class:active={route === slug} href={`#/${slug}`} aria-current={route === slug ? 'page' : undefined}>{label}</a>
  {/each}
</nav>
