 <cfquery name="ObjectList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *, Code+' '+Description as Display
		FROM   #CLIENT.LanPrefix#Ref_Object
		WHERE  1=1
		AND    Code IN (SELECT ObjectCode 
		                FROM   Purchase.dbo.ItemMasterObject 
						WHERE  ItemMaster IN (SELECT Code 
						               FROM  Purchase.dbo.ItemMaster 
									   WHERE (Mission = '#url.mission#' or Mission is NULL or Mission = '')
									  )				  
					   )				  
     	ORDER BY ObjectUsage, HierarchyCode
	</cfquery>
	
	<!-- <cfform> -->
	
	 <cfselect style="width:300px" name="objectcode" id="objectcode" Query="ObjectList" Value="Code" Display="Display" group ="ObjectUsage" class="regularxl" onChange="search('<cfoutput>#URL.view#</cfoutput>')">
		  <option value="" selected>Any</option>       	   
   	   </cfselect>
	   
	<!--  </cfform> -->