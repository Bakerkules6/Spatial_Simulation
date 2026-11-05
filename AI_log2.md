<div style="font-family: 'Helvetica Light', 'Helvetica Neue Light', Helvetica, Arial, sans-serif; font-weight: 300; color: #000000; line-height: 1.55;">

<h1 style="font-family: Helvetica, 'Helvetica Neue', Arial, sans-serif; font-weight: bold; color: #001f5b; border-bottom: 2px solid #000000; padding-bottom: 8px; margin-bottom: 12px;">
AI Interaction &amp; Workflow Log 2: Livestock Movement &amp; Action Neighbourhood Model
</h1>

<p style="margin: 4px 0;"><strong style="font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">Project:</strong> Spatial Simulation — Experiment 2: Livestock Movement &amp; Action Neighbourhoods</p>
<p style="margin: 4px 0;"><strong style="font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">Platform:</strong> GAMA Modeling Platform (GAML) — <code>models/livestock.gaml</code></p>
<p style="margin: 4px 0;"><strong style="font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">Collaborators:</strong> Timotej Gabrijan (Student #12526937) &amp; Jarvis (Antigravity AI Assistant)</p>
<p style="margin: 4px 0;"><strong style="font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">Date:</strong> 5 November 2026</p>
<p style="margin: 4px 0 18px 0;"><strong style="font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">Repository Branch:</strong> <code>livestock_model</code></p>

<h2 style="font-family: Helvetica, 'Helvetica Neue', Arial, sans-serif; font-weight: bold; color: #001f5b; border-bottom: 1.5px solid #000000; padding-bottom: 4px; margin-top: 22px;">
1. Executive Summary
</h2>

<p>
This document records the complete chronological prompt-engineering workflow, model refinements, and version control commits during the development of the <strong>Livestock Movement &amp; Action Neighbourhood Model</strong> in GAMA. The simulation models three livestock species inside a fenced pasture with a corner pond near the origin <code>{0, 0}</code>:
</p>

<ul>
  <li><strong style="font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">5 Black Square Cows:</strong> Move via a correlated random walk (<code>speed = 2.0</code>, max turning angle <code>90°</code>), reflect inward upon reaching any side of the perimeter fence, and stop permanently if they reach the pond.</li>
  <li><strong style="font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">3 Amber Ellipse Sheep:</strong> Move strictly South (<code>heading = 90.0°</code>, where East is <code>0°</code>) at <code>speed = 1.0</code> until reaching the southern fence, reverse North (<code>heading = 270.0°</code>) to the northern fence, and oscillate continuously.</li>
  <li><strong style="font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">2 Grey Triangle Goats:</strong> Spawn at two distinct initial coordinates and walk slowly towards the origin <code>{0, 0}</code> at <code>speed = 0.5</code>, stopping permanently 1 step away from the pond.</li>
</ul>

<h2 style="font-family: Helvetica, 'Helvetica Neue', Arial, sans-serif; font-weight: bold; color: #001f5b; border-bottom: 1.5px solid #000000; padding-bottom: 4px; margin-top: 24px;">
2. Chronological Prompt &amp; Version Control Table
</h2>

<table style="width: 100%; border-collapse: collapse; border: 2px solid #000000; font-family: 'Helvetica Light', 'Helvetica Neue Light', Helvetica, Arial, sans-serif; font-weight: 300; color: #000000; font-size: 13.5px; margin-top: 12px;">
  <thead>
    <tr style="background-color: #f0f4fa; border-bottom: 2px solid #000000;">
      <th style="border: 1px solid #000000; padding: 10px 8px; text-align: center; width: 6%; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">Prompt #</th>
      <th style="border: 1px solid #000000; padding: 10px 8px; text-align: left; width: 18%; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">Prompt Summary</th>
      <th style="border: 1px solid #000000; padding: 10px 8px; text-align: left; width: 22%; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">Content Summary</th>
      <th style="border: 1px solid #000000; padding: 10px 8px; text-align: left; width: 38%; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">Main Changes in the Model</th>
      <th style="border: 1px solid #000000; padding: 10px 8px; text-align: center; width: 16%; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">Git Commit &amp; Versioning</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">1</td>
      <td style="border: 1px solid #000000; padding: 8px;">Initial task specification, step-by-step prompt plan, and Git branch creation</td>
      <td style="border: 1px solid #000000; padding: 8px;">Formulated a modular 5-step prompt execution plan and created the dedicated <code>livestock_model</code> Git branch to isolate development from <code>master</code>.</td>
      <td style="border: 1px solid #000000; padding: 8px;">
        <ul style="margin: 0; padding-left: 18px;">
          <li>Created and switched to branch <code>livestock_model</code>.</li>
          <li>Designed 5 incremental implementation stages covering initialization, species movement rules, and action neighbourhoods.</li>
          <li>Defined concise semantic versioning scheme (<code>version 0.1</code> – <code>2.0</code>).</li>
        </ul>
      </td>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center;">
        Branch:<br><code>livestock_model</code><br><strong>Plan Setup</strong>
      </td>
    </tr>
    <tr>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">2</td>
      <td style="border: 1px solid #000000; padding: 8px;">Execute Step 1: Initialize <code>livestock.gaml</code> with custom agent shapes and colours</td>
      <td style="border: 1px solid #000000; padding: 8px;">Created the GAML model skeleton initializing 5 black square cows, 3 amber ellipse sheep, and 2 grey triangle goats with a 2D GUI display.</td>
      <td style="border: 1px solid #000000; padding: 8px;">
        <ul style="margin: 0; padding-left: 18px;">
          <li>Created <code>models/livestock.gaml</code> with <code>nb_cows &lt;- 5</code>, <code>nb_sheep &lt;- 3</code>, and <code>nb_goats &lt;- 2</code>.</li>
          <li>Configured <code>cow</code> aspect as <code>square(3.0)</code> in <code>#black</code>.</li>
          <li>Configured <code>sheep</code> aspect as <code>ellipse(3.0, 1.8)</code> in <code>#amber</code>.</li>
          <li>Configured <code>goat</code> aspect as <code>triangle(2.5)</code> in <code>#grey</code>.</li>
        </ul>
      </td>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center;">
        Commit: <code>b390d45</code><br><strong>Version 0.1</strong>
      </td>
    </tr>
    <tr>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">3</td>
      <td style="border: 1px solid #000000; padding: 8px;">Execute Step 2: Implement cow correlated random walk</td>
      <td style="border: 1px solid #000000; padding: 8px;">Added the <code>moving</code> skill and correlated random walk reflex to cows at a speed of <code>2.0</code> and maximum turning angle of <code>90°</code>.</td>
      <td style="border: 1px solid #000000; padding: 8px;">
        <ul style="margin: 0; padding-left: 18px;">
          <li>Attached <code>skills: [moving]</code> to <code>species cow</code>.</li>
          <li>Initialized cow <code>speed &lt;- 2.0</code> in <code>global init</code>.</li>
          <li>Implemented <code>reflex cow_move { do wander speed: speed amplitude: 90.0; }</code>.</li>
        </ul>
      </td>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center;">
        Commit: <code>34aed72</code><br><strong>Version 0.2</strong>
      </td>
    </tr>
    <tr>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">4</td>
      <td style="border: 1px solid #000000; padding: 8px;">Execute Step 3: Implement sheep southward movement</td>
      <td style="border: 1px solid #000000; padding: 8px;">Added directed southward movement for all sheep at a speed of <code>1.0</code> using GAMA's clockwise heading convention (East = <code>0°</code>, South = <code>90°</code>).</td>
      <td style="border: 1px solid #000000; padding: 8px;">
        <ul style="margin: 0; padding-left: 18px;">
          <li>Attached <code>skills: [moving]</code> to <code>species sheep</code>.</li>
          <li>Initialized sheep <code>speed &lt;- 1.0</code> in <code>global init</code>.</li>
          <li>Implemented <code>reflex sheep_move { do move speed: speed heading: 90.0; }</code>.</li>
        </ul>
      </td>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center;">
        Commit: <code>45c93ae</code><br><strong>Version 0.3</strong>
      </td>
    </tr>
    <tr>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">5</td>
      <td style="border: 1px solid #000000; padding: 8px;">Execute Step 4: Implement goat movement towards origin <code>{0,0}</code></td>
      <td style="border: 1px solid #000000; padding: 8px;">Added origin-seeking kinematics to goats so they walk slowly towards coordinate <code>{0, 0}</code> at a speed of <code>0.5</code>.</td>
      <td style="border: 1px solid #000000; padding: 8px;">
        <ul style="margin: 0; padding-left: 18px;">
          <li>Attached <code>skills: [moving]</code> to <code>species goat</code>.</li>
          <li>Initialized goat <code>speed &lt;- 0.5</code> in <code>global init</code>.</li>
          <li>Implemented <code>reflex goat_move { do goto target: {0, 0} speed: speed; }</code>.</li>
        </ul>
      </td>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center;">
        Commit: <code>b59130b</code><br><strong>Version 0.4</strong>
      </td>
    </tr>
    <tr>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">6</td>
      <td style="border: 1px solid #000000; padding: 8px;">Execute Step 5: Visualise action neighbourhoods and push to remote</td>
      <td style="border: 1px solid #000000; padding: 8px;">Added <code>action_neighbourhood</code> aspects for all three species to visualise their reachable next-step positions and pushed the branch to GitHub.</td>
      <td style="border: 1px solid #000000; padding: 8px;">
        <ul style="margin: 0; padding-left: 18px;">
          <li>Added forward cone sector <code>circle(speed) intersection cone(heading - 45, heading + 45)</code> for cows.</li>
          <li>Added directional displacement vectors for sheep and goats.</li>
          <li>Layered <code>action_neighbourhood</code> aspects beneath <code>default</code> aspects in the GUI display.</li>
        </ul>
      </td>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center;">
        Commit: <code>659da1c</code><br><strong>Version 0.5</strong>
      </td>
    </tr>
    <tr>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">7</td>
      <td style="border: 1px solid #000000; padding: 8px;">Repair undefined <code>#amber</code> colour constant in GAMA</td>
      <td style="border: 1px solid #000000; padding: 8px;">Replaced the unrecognised CSS constant <code>#amber</code> with explicit RGB values <code>rgb(255, 191, 0)</code> across all sheep aspects.</td>
      <td style="border: 1px solid #000000; padding: 8px;">
        <ul style="margin: 0; padding-left: 18px;">
          <li>Replaced <code>#amber</code> with <code>rgb(255, 191, 0)</code> in <code>sheep</code> <code>default</code> and <code>action_neighbourhood</code> aspects.</li>
          <li>Verified clean compilation in GAMA IDE.</li>
        </ul>
      </td>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center;">
        Commit: <code>535aa4b</code><br><strong>Version 0.6</strong>
      </td>
    </tr>
    <tr>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">8</td>
      <td style="border: 1px solid #000000; padding: 8px;">Add light green pasture background with 70% transparency</td>
      <td style="border: 1px solid #000000; padding: 8px;">Added a semi-transparent light green background layer to the simulation map display.</td>
      <td style="border: 1px solid #000000; padding: 8px;">
        <ul style="margin: 0; padding-left: 18px;">
          <li>Added <code>graphics "Background" transparency: 0.7</code> to <code>display "Livestock Map"</code>.</li>
          <li>Rendered <code>draw world.shape color: rgb(144, 238, 144);</code> as the base environmental layer.</li>
        </ul>
      </td>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center;">
        Commit: <code>052e0cd</code><br><strong>Version 0.7</strong>
      </td>
    </tr>
    <tr>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">9</td>
      <td style="border: 1px solid #000000; padding: 8px;">Add top-view fence and pond PNG assets, align fence edge, and fix goat 1-step neighbourhood</td>
      <td style="border: 1px solid #000000; padding: 8px;">Created transparent top-down PNG sprites for the perimeter fence and corner pond, aligned the fence to the world edge, and restricted the goat's action neighbourhood line to a single step of length <code>speed</code>.</td>
      <td style="border: 1px solid #000000; padding: 8px;">
        <ul style="margin: 0; padding-left: 18px;">
          <li>Created <code>includes/fence.png</code> and <code>includes/pond.png</code> with RGBA transparency.</li>
          <li>Rendered <code>fence_image</code> (<code>size: 106 at: {50, 50}</code>) and <code>pond_image</code> (<code>size: 15</code>).</li>
          <li>Updated goat <code>action_neighbourhood</code> to compute the exact 1-step vector of length <code>speed = 0.5</code> towards <code>{0, 0}</code>.</li>
        </ul>
      </td>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center;">
        Commit: <code>a318db2</code><br><strong>Version 0.9</strong>
      </td>
    </tr>
    <tr>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">10</td>
      <td style="border: 1px solid #000000; padding: 8px;">Implement fence movement restriction and pond stopping mechanics</td>
      <td style="border: 1px solid #000000; padding: 8px;">Restricted all agents to remain inside the fence and added stopping conditions at the pond for goats (1 step away) and cows (upon reaching the pond).</td>
      <td style="border: 1px solid #000000; padding: 8px;">
        <ul style="margin: 0; padding-left: 18px;">
          <li>Defined <code>fence_min &lt;- 3.5</code>, <code>fence_max &lt;- 96.5</code>, <code>pond_location &lt;- {7.5, 7.5}</code>, and <code>pond_radius &lt;- 7.5</code>.</li>
          <li>Added boundary turnaround rules at the fence perimeter for sheep and cows.</li>
          <li>Added <code>stopped</code> boolean state stopping goats at <code>pond_radius + speed</code> and cows at <code>pond_radius</code>.</li>
        </ul>
      </td>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center;">
        Commit: <code>41a0364</code><br><strong>Version 1.0</strong>
      </td>
    </tr>
    <tr>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center; font-family: Helvetica, Arial, sans-serif; font-weight: bold; color: #001f5b;">11</td>
      <td style="border: 1px solid #000000; padding: 8px;">Final refinement of cow wall reflection, sheep N–S oscillation, and distinct goat start locations</td>
      <td style="border: 1px solid #000000; padding: 8px;">Prevented cows from getting trapped along the fence boundary, enforced strict North–South oscillation for sheep, and placed the two goats at separate starting coordinates.</td>
      <td style="border: 1px solid #000000; padding: 8px;">
        <ul style="margin: 0; padding-left: 18px;">
          <li>Cows step inward by <code>speed</code> and redirect <code>heading</code> towards the interior upon hitting any fence wall.</li>
          <li>Added explicit <code>going_south</code> flag for sheep so they move strictly South (<code>90°</code>) and North (<code>270°</code>) between fences.</li>
          <li>Initialized the 2 goats at distinct positions <code>{80.0, 25.0}</code> and <code>{25.0, 80.0}</code>.</li>
        </ul>
      </td>
      <td style="border: 1px solid #000000; padding: 8px; text-align: center;">
        Commit: <code>402f419</code><br><strong>Version 2.0</strong>
      </td>
    </tr>
  </tbody>
</table>

</div>
