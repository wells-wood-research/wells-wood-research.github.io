<script>
  import { Mail } from '@lucide/svelte';
  import { faGithub, faLinkedin } from '@fortawesome/free-brands-svg-icons';
  import BrandIcon from './BrandIcon.svelte';

  export let person;
</script>

<article class:previous={person.active === false} class="people-card">
  <div>
    <img src={person.image} alt={person.name} loading="lazy">
    <div class="social-links">
      {#if person.email}
        <a href={`mailto:${person.email}`} aria-label={`Email ${person.name}`} title="Email"><Mail size={18} strokeWidth={1.8} /></a>
      {/if}
      {#if person.github}
        <a href={person.github} target="_blank" rel="noreferrer" aria-label={`${person.name} on GitHub`} title="GitHub"><BrandIcon icon={faGithub} label="GitHub" /></a>
      {/if}
      {#if person.linkedin}
        <a href={person.linkedin} target="_blank" rel="noreferrer" aria-label={`${person.name} on LinkedIn`} title="LinkedIn"><BrandIcon icon={faLinkedin} label="LinkedIn" /></a>
      {/if}
    </div>
  </div>
  <div>
    <h2>{person.name}</h2>
    {#if person.associatedLab}<p class="associated-lab">Supervised with: {person.associatedLab}</p>{/if}
    <p>{person.bio}</p>
  </div>
</article>
