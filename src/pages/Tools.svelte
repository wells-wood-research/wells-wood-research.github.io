<script>
  import { tools } from '../lib/content.js';
</script>

<section class="page-section">
  <h1>Tools</h1>
  {#each tools as tool}
    <article class:has-image={tool.image} class="tool-card" style={tool.image ? `background-image: url('${tool.image}')` : ''}>
      <h2>{tool.name}</h2>
      <div class="tool-links">
        {#if tool.application}<a href={tool.application} target="_blank" rel="noreferrer">Application</a>{/if}
        {#if tool.source}<a href={tool.source} target="_blank" rel="noreferrer">Source</a>{/if}
      </div>
      <p>{tool.description}</p>
    </article>
  {/each}
</section>
