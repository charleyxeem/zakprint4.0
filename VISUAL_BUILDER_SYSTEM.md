# Visual Page Builder - Complete System Guide

## 🎉 What Changed

The old Content Studio was designed for developers to manage blocks of content through code/JSON editing. We've replaced it with a **Visual Page Builder** - a WYSIWYG (What You See Is What You Get) editor that lets non-technical users manage website content visually.

## 📊 Old vs New

### Old Content Studio (Code-Based)
```
❌ Complex interface
❌ Required HTML/JSON knowledge
❌ Block editing in sidebars
❌ Not visual
❌ Hard to understand for non-technical users
```

### New Visual Page Builder (Visual-Based)
```
✅ Simple, intuitive interface
✅ Drag-and-drop blocks
✅ Live preview as you edit
✅ Click text to edit directly
✅ No coding required
✅ See changes instantly
```

## 🎯 Key Features

### 1. **Live Preview**
The center of the screen shows exactly how your changes will look on the website.

### 2. **Click-to-Edit**
Click any block to edit it. Properties appear on the right.

### 3. **Drag-to-Reorder**
Drag blocks up/down to change order. No confusing sort_order numbers.

### 4. **Block Types**
All supported block types are available as one-click buttons:
- **Text** - Paragraphs, lists, formatting
- **Hero** - Big banner section
- **Image** - Single image with caption
- **Gallery** - Multiple images in grid
- **FAQ** - Questions and answers
- **CTA** - Call-to-action button

### 5. **Properties Panel**
Right side shows all editable settings for the selected block:
- Block title
- Content (HTML or JSON)
- Images, alt text, captions
- FAQ items
- And more

## 🖥️ Interface Layout

```
┌────────────────────────────────────────────────────────────┐
│  Header: Visual Page Builder | Save | Publish             │
├──────────────┬──────────────────────────┬─────────────────┤
│ PAGES (left) │ CANVAS - LIVE PREVIEW    │ PROPERTIES (R) │
│              │                          │                 │
│ • Home       │ [Your page renders here  │ Block Title    │
│ • Shop       │  as you edit]            │ ___________    │
│ • About      │                          │                 │
│              │ Click a block to select  │ Content HTML   │
│ ADD BLOCKS   │ it, then edit on right   │ ___________    │
│              │                          │                 │
│ • Text       │ Drag blocks to reorder   │ Alt Text       │
│ • Hero       │                          │ ___________    │
│ • Image      │                          │                 │
│ • Gallery    │                          │ Save | Delete  │
│ • FAQ        │                          │                 │
│ • CTA        │                          │                 │
└──────────────┴──────────────────────────┴─────────────────┘
```

## 📖 How to Use - Quick Start

### Step 1: Select a Page
Click any page from the **left panel**:
- Home
- Shop
- About
- Contact
- Services
- Etc.

### Step 2: Edit a Block
Click any block in the **center preview area**.

The block highlights in orange, and its properties appear on the **right panel**.

### Step 3: Make Changes
Edit content in the **right panel**. You'll see changes in the **center preview** instantly.

### Step 4: Save
Click the **Save** button (top right) to save your changes.

### Step 5: Publish
Click the **Publish** button to make changes live on the website.

## 🎨 Working with Different Block Types

### Text Block
Edit rich content with:
- Headings (`<h1>`, `<h2>`, `<h3>`)
- Paragraphs (`<p>`)
- Bold/italic (`<strong>`, `<em>`)
- Lists (`<ul>`, `<ol>`)
- Links (`<a href="">`)

Example:
```html
<h2>About Us</h2>
<p>We provide high-quality printing services.</p>
<ul>
  <li>Fast turnaround</li>
  <li>Quality materials</li>
  <li>Competitive prices</li>
</ul>
```

### Hero Block
Large banner at top of page. Edit:
- Headline (`<h1>`)
- Description (`<p>`)
- Optional: CTA button

Example:
```html
<h1>Welcome to ZAK Printing</h1>
<p>Premium custom printing for your brand</p>
<a href="#contact" class="cta-button">Get Started</a>
```

### Image Block
Single image with optional caption. Edit:
- **Image URL** - Direct link to image
- **Alt Text** - Description for accessibility
- **Caption** - Text below image

### Gallery Block
Multiple images in a grid. Provide as JSON:

```json
[
  {"src": "https://example.com/image1.jpg", "alt": "Product 1"},
  {"src": "https://example.com/image2.jpg", "alt": "Product 2"},
  {"src": "https://example.com/image3.jpg", "alt": "Product 3"}
]
```

### FAQ Block
Questions and answers. Provide as JSON:

```json
[
  {"q": "How long is delivery?", "a": "2-3 business days"},
  {"q": "What's your warranty?", "a": "1 year full coverage"},
  {"q": "Do you ship internationally?", "a": "Yes, worldwide shipping"}
]
```

### CTA Block
Call-to-action section with button. Edit HTML:

```html
<h3>Ready to Order?</h3>
<p>Contact us for a custom quote</p>
<a href="/contact" class="cta-button">Contact Now</a>
```

## 🎯 Common Workflows

### Workflow 1: Update Home Page Hero
1. Click **Home** (left panel)
2. Click the hero banner (center)
3. Edit HTML in right panel:
   ```html
   <h1>New Headline</h1>
   <p>Your new description</p>
   ```
4. Click **Save**
5. Click **Publish**

### Workflow 2: Add Images to Gallery
1. Click page with gallery
2. Click gallery block
3. Edit JSON in right panel:
   ```json
   [
     {"src": "url1", "alt": "Photo 1"},
     {"src": "url2", "alt": "Photo 2"}
   ]
   ```
4. Save and publish

### Workflow 3: Create New FAQ
1. Click page
2. Click **FAQ** button (left panel) - adds new FAQ block
3. Edit JSON:
   ```json
   [
     {"q": "Question 1?", "a": "Answer 1"}
   ]
   ```
4. Save and publish

### Workflow 4: Reorder Blocks
1. Click page
2. **Drag blocks** in center area
3. Drag above/below to reorder
4. Changes save automatically

### Workflow 5: Delete a Block
1. Click block to select
2. Click red **Delete** button (right panel)
3. Confirm deletion
4. Save and publish

## 🔧 Advanced: HTML Formatting

You can use standard HTML in text blocks. Supported tags:

```html
<!-- Headings -->
<h1>Largest heading</h1>
<h2>Medium heading</h2>
<h3>Smaller heading</h3>

<!-- Text -->
<p>Paragraph</p>
<strong>Bold text</strong>
<em>Italic text</em>
<u>Underlined</u>

<!-- Lists -->
<ul>
  <li>Bullet point 1</li>
  <li>Bullet point 2</li>
</ul>

<ol>
  <li>Numbered 1</li>
  <li>Numbered 2</li>
</ol>

<!-- Links -->
<a href="https://example.com">Click here</a>
<a href="#section">Jump to section</a>

<!-- Formatting -->
<blockquote>Quote or highlight</blockquote>
<hr> <!-- Horizontal line -->

<!-- Images -->
<img src="url" alt="Description" />

<!-- Classes for styling -->
<div class="cta-button">Click me</div>
```

## 💡 Important Things to Know

### Save vs Publish
- **Save** = Stores your changes in the database
- **Publish** = Makes changes visible to website visitors
- Always Save before Publish
- You can Save without Publishing (work in progress)

### Live Preview
- The center area updates as you type
- See exactly how changes will look
- Mobile-responsive layout

### Blocks Can't Be Moved Between Pages
- Each page has its own set of blocks
- To use same content on multiple pages, edit each page separately

### HTML/JSON is Flexible
- You can paste content from other sources
- Long HTML is fine
- JSON must be valid (check commas, quotes)

### Image URLs Must Be Public
- Use links to publicly accessible images
- Google Drive, Imgur, Pinterest, etc. work
- Copy full image URL (not just page URL)

## ✅ Best Practices

1. **Save Often** - Click Save every few edits
2. **Test Before Publishing** - Make sure preview looks good
3. **Use Clear Language** - Simple is better
4. **Quality Images** - Use high-resolution images
5. **Mobile Check** - Ensure blocks look good on phones
6. **One Change at a Time** - Edit one block, save, then next
7. **Don't Mix Formatting** - Don't manually create columns in text
8. **Keep Content Updated** - Regular updates help SEO

## 🆘 Troubleshooting

### Problem: Block won't save
- Make sure you clicked **Save** button
- Check HTML/JSON syntax if using advanced content
- Try refreshing page if broken

### Problem: Changes not showing on website
- Did you click **Publish**? (not just Save)
- Wait a few seconds for changes to propagate
- Try clearing browser cache (Ctrl+Shift+Delete)

### Problem: Image not loading
- Check image URL is correct (starts with https://)
- Make sure image URL is publicly accessible
- Try different image

### Problem: JSON error (Gallery/FAQ)
- Check commas: `{"a":"b"},{"c":"d"}` ✓
- Check quotes: `"text"` not `'text'` ✓
- No trailing commas: `[1,2,3]` not `[1,2,3,]` ✗
- Use JSON validator: jsonlint.com

### Problem: HTML not formatting correctly
- Close all tags: `<p>text</p>` ✓
- Use lowercase tags: `<p>` not `<P>` ✓
- No special characters without escaping

## 📱 Mobile Responsive

All blocks are automatically responsive:
- Text blocks become easier to read on mobile
- Images scale down
- Galleries become single column
- Buttons become full width if needed

No special mobile editing needed!

## 🔐 Security & Permissions

- Only Super Admins can access Visual Page Builder
- All changes are logged
- HTML is allowed (assuming admin is trusted)
- Database is protected

## 🚀 Migration from Old Content Studio

If you were using the old Content Studio:

**Before (Old Way):**
```
Edit cms.php → Manage blocks in code → JSON format → No preview
```

**After (New Way):**
```
Click page → Click block → Edit visually → See live preview → Save → Publish
```

All old content is still there! The database hasn't changed. Just the interface is new and better.

## 📞 Support

**Still have questions?**
- Read `VISUAL_BUILDER_GUIDE.md` for detailed user guide
- Check examples in block types above
- Contact admin team

## 🎓 Training

### For Non-Technical Users
1. Read `VISUAL_BUILDER_GUIDE.md` (5 min)
2. Log in and try editing one block (10 min)
3. Congratulations! You're ready

### For Developers
1. Read this guide (10 min)
2. Review the HTML/code section (5 min)
3. You're good to go

### For Admins
1. Review this entire document
2. Review permissions and roles
3. Setup backup procedures
4. Train users

## 📋 Migration Checklist

If migrating from old Content Studio to Visual Builder:

- [ ] All pages still accessible
- [ ] All blocks still loading
- [ ] Images displaying correctly
- [ ] Text formatting intact
- [ ] FAQ items showing properly
- [ ] Gallery items displaying
- [ ] Save/Publish working
- [ ] Users trained on new interface

## 🎉 Final Notes

The Visual Page Builder is designed to **make content management easy** for everyone - not just developers.

**If something feels complicated, it's probably not the right way. Use the simpler method!**

---

**Ready to go?** Head to the Admin Dashboard and click **Visual Page Builder** to get started!

**Questions?** Read the VISUAL_BUILDER_GUIDE.md for step-by-step instructions.
