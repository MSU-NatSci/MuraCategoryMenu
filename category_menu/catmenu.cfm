<cffunction name="outputCategoryMenu" output="true">
	<cfargument name="parentID">
	<cfargument name="parentURL">
	<cfargument name="parentLabelID">
	<cfargument name="depth">

    <cfset var feedBean = m.getFeed('category').where().prop('parentID').isEQ(parentID)>
    <cfset var iterator = feedBean.getIterator()>
    <cfif iterator.hasNext()>
        <ul class="categoryList" role="#(depth eq 0 ? 'tree' : 'group')#" aria-labelledby="#parentLabelID#">
            <li id="cat_#parentID#" class="categoryItem" category-url="#parentURL#">
                <a href="#parentURL#" class="categoryTitle" role="treeItem" aria-level="#depth + 1#" aria-selected="false">All</a>
            </li>
            <cfloop condition="iterator.hasNext()">
                <cfset var cat = iterator.next()>
                <cfset var catID = cat.getCategoryID()>
                <cfset catURL = parentURL & cat.getURLTitle() & '/'>
                <li id="cat_#catID#" class="categoryItem" category-url="#catURL#">
                    <cfset labelID = "menu_#createUUID()#">
                    <a id="#labelID#" href="#catURL#" class="categoryTitle" role="treeItem" aria-level="#depth + 1#" aria-selected="false">#cat.getName()#</a>
                    <cfset outputCategoryMenu(catID, catURL, labelID, depth + 1)>
                </li>
            </cfloop>
        </ul>
    </cfif>
</cffunction>
