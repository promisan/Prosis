
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

