<cfparam name="objectParams.parent" default="" />
<cfparam name="objectParams.ui" default="list" />
<cfparam name="objectParams.title" default="" />

<!--- we need this test and an external include to avoid issues when the template
      is used serveral times on the same page --->
<cfif structKeyExists(variables, 'outputCategoryMenu') eq 'NO'>
    <cfinclude template="catmenu.cfm" />
</cfif>

<cfoutput>
    <cfif objectParams.parent eq ''>
        <p>Select a parent category in the object parameters and publish the page to update.</p>
    <cfelse>
        <cfset webRoot = m.getBean('configBean').getWebRoot()>
        <cfset templatePath = getCurrentTemplatePath()>
        <cfset moduleWebPath = getDirectoryFromPath(replace(templatePath.mid(webRoot.len() + 1,
            templatePath.len() - webRoot.len()), '\', '/', 'all'))>
        <script>
Mura(function(m) {
    m.loader().loadcss('#moduleWebPath#category_menu.css');
});
        </script>
        <cfset contentURL = '/' & m.content().getFilename()>
        <cfset parentID = objectParams.parent>
        <cfset parentCategory = m.getBean('category').loadBy(categoryID=parentID)>
        <cfif objectParams.title neq ''>
            <cfset title = objectParams.title>
        <cfelse>
            <cfset title = parentCategory.getName()>
        </cfif>
        <cfset elementID = "catmenu_#createUUID()#">
        <cfif parentCategory.exists()>
            <cfset parentURL = contentURL & '/category/' & parentCategory.getFilename() & '/'>
            <cfif objectParams.ui eq 'dropdown'>
                <cfset feedBean = m.getFeed('category').where().prop('parentID').isEQ(parentID)>
                <cfset iterator = feedBean.getIterator()>
                <select id="#elementID#" class="categorySelect">
                    <option value="#parentID#" category-url="#parentURL#">#title#</option>
                    <cfloop condition="iterator.hasNext()">
                        <cfset cat = iterator.next()>
                        <option value="#cat.getCategoryID()#" category-url="#parentURL##cat.getURLTitle()#/">&nbsp;&nbsp;#cat.getName()#</option>
                    </cfloop>
                </select>
            <cfelse>
                <nav id="#elementID#" class="categoryMenu" style="display:none">
                    <cfset menuLabelID = "menu_#createUUID()#">
                    <a id="#menuLabelID#" href="##" class="categoryTitle">#title#</a>
                    <cfset outputCategoryMenu(parentID, parentURL, menuLabelID, 0)>
                </nav>
            </cfif>
            <script>
{
    let elt = document.getElementById('#elementID#');
    if (typeof init_category_menu === "function") {
        init_category_menu(elt);
    } else {
        let script = document.createElement('script');
        script.onload = function() {
            init_category_menu(elt);
        };
        script.src = '#moduleWebPath#category_menu.js';
        elt.parentNode.appendChild(script);
    }
}
            </script>
        <cfelse>
            <p>Could not find the parent category.</p>
        </cfif>
    </cfif>
</cfoutput>

