<script>
  export let icon;
  export let label;
  export let size = 18;
</script>

<svg width={size} height={size} viewBox={`0 0 ${icon.icon[0]} ${icon.icon[1]}`} role="img" aria-label={label} fill="currentColor" aria-hidden="true">
  {#each Array.isArray(icon.icon[4]) ? icon.icon[4] : [icon.icon[4]] as path}
    <path d={path} />
  {/each}
</svg>
