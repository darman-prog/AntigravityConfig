# Visualize: Direction Comps & Asset Production

Load this from [new-work.md](new-work.md) on a comp-led build, when image generation is available (via the `image-generator` subagent or native image tool). A code-led contract skips this file by design, not by drift; do not load it then. `PRODUCT.md` and `DESIGN.md` are preconditions. [new-work.md](new-work.md) has already resolved the visual world; this file must not reopen it.

A probe tests composition, narrative, hierarchy, density, focal moment, signature use, and image requirements. It is not a second identity workshop. Keep `DESIGN.md`'s palette, typography direction, material language, component character, imagery stance, and motion grammar fixed.

## Generate three compositional options

Render three distinct high-fidelity north-star comps of the requested surface at the surface's own viewport: portrait at device size for a native app or mobile-first surface, desktop landscape otherwise; a phone screen comped landscape misstates the composition before anything is built against it. Base the comps on real content and the surface concepts already developed with the user. On an established world, anchor every comp on the real identity: capture a screenshot of a representative existing page and pass it as a reference image; the prompt leads with the new surface's structure while the reference carries palette, type, and component character, because `DESIGN.md` words alone drift where a pixel reference does not. Name what the reference contributes and what it must not: chrome, palette, type, and component character carry over; the reference page's own content does not, and a banner, hero, or card lifted verbatim is the reference leaking, not fidelity. Three is the number: one comp invites rubber-stamping; the spread between three surfaces the composition worth building.

- A comp is a designed surface, not a picture of the subject. Lead the prompt with the surface's own structure: the regions this design has, named in order with their scale relationships; a page with no navigation says so instead of inventing one, and an unconventional surface states its unconventional skeleton. A prompt that leads with atmosphere gets a vignette back: the model paints the fish market instead of the fish market's website. Self-check every render: if it could hang as a poster, or reads as a photograph with some text on it, it is not a comp; regenerate with the layout scaffold stated more literally.
- The inverse is also a failure: a surface with none of its subject in it. The subject appears as the content the regions hold; the world dresses the frame and never displaces what the frame shows. The deletion usually rides in on the prompt's exclusion list, so exclusions bind invented claims, and a medium ban belongs to the committed imagery stance, never to caution. Before accepting a render, point at the subject; a render that depicts everything about the world and nothing of the subject fails however faithful its atmosphere. Regenerate with the subject's content named region by region.
- Judge a comp as the shipped screen: the visitor's job must be readable from the image alone. Name the surface's mode from the render with no caption; a render whose mode cannot be read back is art direction without a surface. Regenerate with the visitor's job as the prompt's spine.
- Commitment is depth, not coverage. The world enters through one dominant move plus the material, type, and spacing that support it; the remaining regions hold still so that move can be read. A region that simply does its job in the world's grammar carries the direction further than a region performing the concept. The check cuts competition, never content: a quieted region keeps its information and stops performing. A second element competing with the named focal moment at the same scale means the comp is shouting; with no named focal moment, several regions performing the concept at once is the same shout. Regenerate keeping the strongest move and quieting the rest. Busy is louder, not bolder.
- When the user shortlisted multiple concepts, spread the three across them.
- When one direction is committed, vary the structural uncertainty an image can resolve: topology, sequence, density, hierarchy, focal composition, or interaction framing.
- Show enough beyond the opening moment to prove the concept can govern the whole surface.
- Do not generate a palette artifact, ask new atmosphere questions, introduce a different type voice, or invent a new motif. If the committed world cannot support the concept, return to the concept shortlist rather than changing the world.

Each comp is a direction test, not a screenshot specification. Core UI text, responsive behavior, accessibility, semantics, and interaction states remain implementation responsibilities.

## One approval point

Show the three options to the user and ask (via `ask_question` or direct prompt) what should carry forward, what feels false to the world, and whether the selected concept should be approved, combined, revised, or rejected. Then stop and wait.

Do not begin code until the user approves a direction or explicitly delegates the choice. If they delegate, choose using the task brief, `PRODUCT.md`, and `DESIGN.md`, and state the evidence. Approval refines the task concept; it does not modify `DESIGN.md`.

After approval, record the approved comp's path in the surface brief, summarize the composition and the parts of the comp that must not be literalized, return to [new-work.md](new-work.md), record the direction contract from the approved concept, and build.

## After approval: the comp becomes a spec

The approved comp is a north star for translation into semantic, responsive, accessible code, never a license to recompose: keeping the palette and mood while redrawing the topology is a second art direction. Do not rasterize core UI text or controls. Do not substitute a different visual driver after approval without asking.

What the comp shows is measured, not remembered. The medium of every region follows from what the pixels are, never from what feels buildable: a figure, a product object, machinery, any illustration with perspective, shading, or drawing skill in it, and any texture by name (woven cloth, paper grain, fabric, leather, brushed metal) is a `plate` / `image` / `texture` region and ships as a raster; text, controls, chrome, diagrams with countable elements, flat shape systems, and anything that must move, scale, or respond are semantic. Writing "CSS" for a sculpted panel's finish, or a many-vertex `clip-path` for a torn edge, is the quiet deletion of the approved design. Dropping an image-native region is a scope decision the user makes at the approval point, never a silent flattening after it. Generated imagery is a material, not a claim: evidence rules bind assertions, specs, testimonials, and photographs presented as real, never render fidelity.

## Plates and provenance

Every raster region's plate is produced before page code, using the image generator tool with the region's visual specification. After generating any image, verify it manually against [craft-floor.md](craft-floor.md).

Return to [new-work.md](new-work.md) for the direction contract, the build, and the finishing pass.
