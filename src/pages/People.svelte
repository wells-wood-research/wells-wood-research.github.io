<script>
  import Advert from '../lib/Advert.svelte';
  import Person from '../lib/Person.svelte';
  import { people } from '../lib/content.js';

  const leader = people.find((person) => person.group === 'groupLeader');
  const byFirstName = (a, b) => a.name.split(' ')[0].localeCompare(b.name.split(' ')[0]);
  const activePeople = (group) => people.filter((person) => person.group === group && person.active).sort(byFirstName);
  const previousPeople = people.filter((person) => person.group !== 'groupLeader' && !person.active).sort(byFirstName);
</script>

<section class="page-section">
  <h1>People</h1>
  <h2>Group Leader</h2>
  {#if leader}<Person person={leader} />{/if}
  {#if activePeople('postDocs').length}
    <h2>Post Doctoral Research Associates</h2>
    {#each activePeople('postDocs') as person}<Person {person} />{/each}
  {/if}
  {#if activePeople('phdStudents').length}
    <h2>PhD Students</h2>
    {#each activePeople('phdStudents') as person}<Person {person} />{/each}
  {/if}
  {#if activePeople('mastersStudents').length}
    <h2>Masters Students</h2>
    {#each activePeople('mastersStudents') as person}<Person {person} />{/each}
  {/if}
  {#if activePeople('undergraduateStudents').length}
    <h2>Undergraduate Students</h2>
    {#each activePeople('undergraduateStudents') as person}<Person {person} />{/each}
  {/if}
  {#if previousPeople.length}
    <h2>Previous Members</h2>
    <div class="previous-people">
      {#each previousPeople as person}<Person {person} />{/each}
    </div>
  {/if}
  <h1>Join Us</h1>
  <Advert />
</section>
