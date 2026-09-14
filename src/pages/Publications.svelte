<script>
  import { publications } from '../lib/content.js';
</script>

<section class="page-section">
  <h1>Publications</h1>
  {#each publications.slice().reverse() as publication, index}
    <article class="publication-item">
      <h2><a href={publication.link} target="_blank" rel="noreferrer">{publications.length - index}. {publication.title}</a></h2>
      <p>{publication.authors}</p>
       <p>{publication.journal}, {publication.volume}{#if publication.issue}({publication.issue}){/if}, {publication.pages}, {publication.year}.</p>
      {#if publication.preprintLink}<a href={publication.preprintLink} target="_blank" rel="noreferrer">Preprint</a>{/if}
    </article>
  {/each}
</section>
