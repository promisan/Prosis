<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfquery name="Class" 
	datasource="AppsControl"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM    Class
	where SystemModule='System'
    ORDER BY ClassName
</cfquery>	

<cfquery name="Types" 
	datasource="AppsControl"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM    Ref_FunctionType
    ORDER BY ListingOrder
</cfquery>	 

<cfform>

<table class="tree" width="100%" height="100%"><tr><td valign="top" style="padding-left:5px">

	<cftree name="root"
		        font="Verdana"
		        fontsize="11"		
		        bold="No"   
				format="html"    
		        required="No">
				
			<cftreeitem value="Advanced"
	            display="Advanced Search"
				parent="special"
				href="javascript:list('LOC','','#url.id2#')">	
			
			<cftreeitem value="UCASE"
		            display="<span style='padding-top:3px;padding-bottom:3px;color: B08C42;' class='labellarge'><b>Use Case Categories</span>"					
		           	expand="Yes">	
					
				<cfloop query="Class" >	
						
						<cftreeitem value="#Class.ClassId#"
		            display="#Class.ClassName#"
		            parent="UCASE"
		            img="#SESSION.root#/Images/#image#"
		            queryasroot="No"
					href="javascript:ClassList('#Class.ClassId#')"
		            expand="No">						
					
						<cfloop query="Types" >	
					
								<cftreeitem value="#Types.Code#_#Class.ClassId#"
					            display="#Types.Name#"
					            parent="#Class.ClassId#"
					            queryasroot="No"
								href="javascript:ClassListType('#Class.ClassId#','#Types.Code#')"
					            expand="No">						
					
						</cfloop>
				 </cfloop>
			
	</cftree>
		</td></tr></table>	
</cfform>

