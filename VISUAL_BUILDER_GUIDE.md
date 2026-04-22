# Visual Page Builder - User Guide

Welcome to the Visual Page Builder! This is a simple, visual editor for non-technical users to create and manage website content.

## 🎨 Interface Overview

The Visual Page Builder has three main areas:

```
┌─────────────────────────────────────────────────────────────┐
│  ← Back | Visual Page Builder | Save | Publish              │
├──────────────┬────────────────────────────┬─────────────────┤
│              │                            │                 │
│  Pages List  │   Live Preview (Canvas)   │  Properties     │
│  - Home      │                            │  Panel          │
│  - Shop      │   (Shows your page as     │                 │
│  - About     │    you edit it!)           │  Edit settings  │
│  - Services  │                            │  for selected   │
│              │                            │  block          │
│  Add Blocks  │                            │                 │
│  - Text      │                            │                 │
│  - Hero      │                            │                 │
│  - Image     │                            │                 │
│  - Gallery   │                            │                 │
│  - FAQ       │                            │                 │
│  - CTA       │                            │                 │
│              │                            │                 │
└──────────────┴────────────────────────────┴─────────────────┘
```

## 📖 Step-by-Step Guide

### 1. Select a Page to Edit

On the left side, you'll see a list of pages:
- **Home** (with house icon)
- **Shop** (with storefront icon)
- **About** (with info icon)
- **Contact** (with mail icon)
- **Services** (with build icon)
- And more...

**Click any page** to select it. The page will load in the center and show all current blocks.

Status indicators:
- 🟢 **Green badge** = Page is Live (published)
- 🔘 **Gray badge** = Page is Draft (not published yet)

### 2. Edit Existing Content

Once a page is loaded, you'll see blocks of content in the center.

**To edit a block:**
1. Click on the block in the center area
2. The block will highlight with an orange border
3. The right panel will show all editable properties for that block

#### Edit Different Block Types:

**Text Block:**
- Shows content directly
- Edit HTML in the right panel
- You can use: `<h1>`, `<h2>`, `<p>`, `<strong>`, `<em>`, etc.

**Hero Section:**
- Large banner at top of page
- Edit headline and description
- Change background color/image if needed

**Image Block:**
- Shows a single image
- Edit: Image URL, Alt text, Caption
- Just paste image URLs

**Gallery:**
- Multiple images in a grid
- Edit as JSON format: `[{"src":"url","alt":"text"},...]`
- Easy way: upload images, copy URLs, paste them

**FAQ:**
- Questions and answers
- Edit as JSON: `[{"q":"Question?","a":"Answer..."},...]`
- Good for: common questions about products/services

**Call-to-Action (CTA):**
- Button or action section
- Edit: Button text, link, color

### 3. Add New Blocks

On the left side, click any of these buttons to add a new block to your page:

- **Text** - Plain text, paragraphs, lists
- **Hero Section** - Big banner with headline
- **Image** - Single image with caption
- **Gallery** - Multiple images in grid
- **FAQ** - Questions and answers
- **CTA** - Call-to-action button

New blocks are added at the bottom. You can drag them to rearrange (see below).

### 4. Rearrange Blocks (Drag & Drop)

To move a block up or down on your page:

1. **Click and hold** the block in the center
2. **Drag** it to the new position
3. **Release** to drop it there
4. Changes save automatically

You can see the drag handle (⋮⋮) when you hover over a block.

### 5. Delete Blocks

To remove a block:

1. Click the block to select it
2. In the right panel, click the red **delete** button
3. Confirm deletion
4. Block is removed

### 6. Save Your Work

Click the **Save** button in the top right:
- Saves all your changes
- You'll see a green notification "Changes saved"
- Changes are saved to the database
- Saved ≠ Published (see below)

### 7. Publish Your Page

Click the **Publish** button to make your changes visible to website visitors:

1. Click the green **Publish** button (top right)
2. A notification appears: "Page published!"
3. Changes are now live on the website
4. Visitors will see your new content

**Important:** Always **Save** before **Publish**. Publishing saves AND activates the page.

## 🎯 Common Tasks

### Task: Edit the Home Page Hero

1. Click "**Home**" on the left
2. Click the hero section (big colorful banner)
3. Edit the text in the right panel:
   ```html
   <h1>Your New Headline</h1>
   <p>Your description here</p>
   ```
4. Click **Save**
5. Click **Publish**

### Task: Add Images to Gallery

1. Select the "**Gallery**" block
2. In the right panel, find the JSON section
3. Replace the URLs with your image URLs:
   ```json
   [
     {"src":"https://example.com/image1.jpg","alt":"Photo 1"},
     {"src":"https://example.com/image2.jpg","alt":"Photo 2"}
   ]
   ```
4. Save and publish

### Task: Update FAQ

1. Find or create an FAQ block
2. Edit as JSON in the right panel:
   ```json
   [
     {"q":"How long does delivery take?","a":"2-3 business days"},
     {"q":"What's your return policy?","a":"30 days full refund"}
   ]
   ```
3. Save and publish

### Task: Add a New Text Section

1. Click the **Text** button on the left
2. Click in the new block in the center
3. Edit the HTML in the right panel
4. Add content like:
   ```html
   <h2>About Us</h2>
   <p>We are a printing company...</p>
   <ul>
     <li>High quality</li>
     <li>Fast turnaround</li>
     <li>Great prices</li>
   </ul>
   ```
5. Save and publish

## 💡 Tips & Tricks

### Tip 1: See Changes Instantly
The center area updates as you type. See your changes in real-time!

### Tip 2: HTML Help
Common HTML you can use:

```html
<h1>Big Headline</h1>
<h2>Medium Headline</h2>
<p>Paragraph text</p>

<strong>Bold text</strong>
<em>Italic text</em>

<ul>
  <li>Bullet point 1</li>
  <li>Bullet point 2</li>
</ul>

<a href="https://example.com">Link text</a>

<button>Button</button>
```

### Tip 3: Image URLs
You can paste image URLs from:
- Google Drive (right-click image → Get link)
- Any website (right-click → Copy image link)
- Imgur, Pinterest, etc.

Just paste the full URL into the Image URL field.

### Tip 4: Before Publishing
Always:
1. ✓ Click **Save** first
2. ✓ Check the preview looks good
3. ✓ Then click **Publish**

### Tip 4: Copy Text Between Blocks
You can copy/paste text from one block to another to reuse content.

## 🆘 Troubleshooting

### "Nothing appears when I edit"
- Make sure you clicked **Save** after making changes
- Check the center area - it should show your updates
- If not, refresh the page and try again

### "My changes disappeared"
- Did you click **Save**? Always click Save first
- If changes still missing, contact your admin

### "Page won't publish"
- Click **Save** first (then Publish)
- Make sure a page is selected
- Try again or contact admin

### "Images not showing"
- Check the URL is correct (should start with https://)
- Try a different image URL
- Make sure the image URL is public/accessible

### "HTML not working"
- Check spelling: `<p>` not `<p >`
- Close all tags: `<p>text</p>`
- No special characters or smart quotes

## 📱 Best Practices

1. **Save Often** - Click Save every few changes
2. **Small Changes** - Edit one block at a time
3. **Preview First** - Check the center area before publishing
4. **Clear Text** - Use simple language
5. **Good Images** - Use clear, high-quality images
6. **Test Links** - If you add links, test they work
7. **Mobile Check** - Blocks should work on phones too

## 🚀 Getting Started Right Now

1. **Pick a page** - Click Home (or any page)
2. **Click a block** - Select something to edit
3. **Change something** - Edit text in the right panel
4. **Watch preview** - See changes in center area
5. **Click Save** - Save your work
6. **Click Publish** - Make it live!

That's it! You're now editing your website content.

## 📞 Need Help?

- **Forgot how to edit?** - Re-read the "Edit Existing Content" section
- **Block won't save?** - Click Save button manually
- **Image not appearing?** - Check the URL is correct
- **Something broke?** - Refresh page (Ctrl+R) or contact admin

---

**Welcome to Visual Page Builder!** 🎉

You now have the power to update your website without any coding knowledge.

Happy editing!
