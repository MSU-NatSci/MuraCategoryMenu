<cfparam name="objectParams.parent" default="" />
<cfparam name="objectParams.ui" default="list" />
<cfparam name="objectParams.title" default="" />

<cfscript>
    feedBean = m.getFeed('category').where()
        .prop('isactive').isEQ(1);
    iterator = feedBean.getIterator();
</cfscript>

<cf_objectconfigurator> <!--- cf_objectconfigurator adds default inputs --->
    <cfoutput>
        <div class="mura-control-group">
            <label for="select_parent_category">Parent Category</label>
            <select id="select_parent_category" name="parent" class="objectParam">
                <cfloop condition="iterator.hasNext()">
                    <cfset cat = iterator.next()>
                    <cfset catID = cat.getCategoryID()>
                    <!--- make sure it has at least one child, or skip --->
                    <cfset childFeed = m.getFeed('category').where().prop('parentID').isEQ(catID)>
                    <cfset childIterator = childFeed.getIterator()>
                    <cfif childIterator.hasNext()>
                        <cfset catName = cat.getName()>
                        <option value="#catID#"<cfif objectParams.parent eq catID> selected</cfif>>#catName#</option>
                    </cfif>
                </cfloop>
            </select>
        </div>
        <div class="mura-control-group">
            <label for="select_ui">User Interface</label>
            <select id="select_ui" name="ui" class="objectParam">
                <option value="list"<cfif objectParams.ui eq 'list'> selected</cfif>>Hierarchical List</option>
                <option value="dropdown"<cfif objectParams.ui eq 'dropdown'> selected</cfif>>Dropdown menu</option>
            </select>
        </div>
        <div class="mura-control-group">
            <label>Title</label>
            <input type="text" name="title" class="objectParam"
                value="#esapiEncode('html_attr', objectParams.title)#" />
        </div>
    </cfoutput>
</cf_objectconfigurator>
