<script>
  import { news } from '../lib/content.js';

  const sortedNews = news.slice().sort((a, b) => new Date(b.date) - new Date(a.date));
</script>

<section class="page-section">
  <h1>News</h1>
  {#each sortedNews as item}
    <article class="news-item">
      <h2>{item.title}</h2>
      <p class="meta">{item.date}, {item.category}</p>
      {#if item.image}<img src={item.image} alt={item.alt} loading="lazy">{/if}
      <p>{item.text}</p>
      {#if item.links.length}
        <p class="news-links">
          {#each item.links as link}<a href={link.url} target="_blank" rel="noreferrer">{link.label}</a>{/each}
        </p>
      {/if}
    </article>
  {/each}
</section>
