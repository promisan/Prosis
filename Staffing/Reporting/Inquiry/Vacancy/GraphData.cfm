
<cfparam name="URL.Print" default="0">
<cfif url.print eq "1">
	<cfset w = 660>
<cfelse>
	<cfset w =  client.width-340>
</cfif>

<cfparam name="url.print" default="0">

<cfquery name="Mission" 
    datasource="AppsQuery" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT *
	FROM    #SESSION.acc#_AppStaffingDetail_#url.fileno#	
</cfquery>

<!---
<cfif url.print eq "0">
--->
	
	<cfoutput>
	
	<script>
	 function printme() {
	  window.open("../Inquiry/Vacancy/GraphData.cfm?format=#url.format#&scope=#url.scope#&fileno=#url.fileno#&print=1&#cgi.query_string#")  
	 }
	</script>
	</cfoutput>

	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td height="4"></td></tr></td>
	<tr>
		<td class="labelit">
			<cfoutput>
				<span id="printTitle" style="display:none;"><cf_tl id="Vacancies"> #Mission.mission# per #dateformat(now(), CLIENT.DateFormatShow)#</span>
				<cf_tl id="Print" var="1">
				<cf_button2 
					mode		= "icon"
					type		= "Print"
					title       = "#lt_text#" 
					id          = "Print"					
					height		= "30px"
					width		= "35px"
					printTitle	= "##printTitle"
					printContent = ".clsPrintContentImage">
			</cfoutput>
		</td>
	</tr>
	</table>	
	
<!---	
		
<cfelse>	
	
	<table width="97%" align="center">
	
		<tr><td height="40" class="labellarge">
		
		<cfoutput>
		Vacancies #Mission.mission# per #dateformat(now(), CLIENT.DateFormatShow)#
		</cfoutput>
		
		</td></tr>
		<tr><td height="1" class="line"></td></tr>
		<tr><td height="15"</td></tr>
		<tr class="noprint">
		   <td class="labelit">Attention : use horizontal settings</td>
	    </tr>
	</table>	
	
	<script>window.print()</script>

</cfif>	

--->


<!--- does not have to be changed usually --->
<cfparam name="url.Nationality"   default="">
<cfparam name="url.OrgUnitOperational" default="">
<cfparam name="url.OfficerUserId" default="">
<cfparam name="url.Print"         default="0">
<cfparam name="url.format"        default="Bar">
<cfparam name="url.item"          default="PostGradeBudget">

<cfsavecontent variable="qry">
		<cfoutput>		
		SELECT  #URL.Item#, 
		        COUNT(DISTINCT PositionNo) AS countedPosition, 
				COUNT(DISTINCT PersonNo) AS Occupied, 
				COUNT(DISTINCT PositionNo) - COUNT(DISTINCT PersonNo) AS Vacant	
		FROM    #SESSION.acc#_AppStaffingDetail_#url.fileno#	
		WHERE   1=1 
		<!---
		#preservesingleQuotes(OrgFilter)#	
		--->	
		#preserveSingleQuotes(client.programgraphfilter)#		
		</cfoutput>	
</cfsavecontent>	

<cfswitch expression="#URL.Item#">
			 
	 <cfcase value="PostClass">
	 	
	 	<cfquery name="Graph" 
	    datasource="AppsQuery" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			#preserveSingleQuotes(qry)#
			GROUP BY PostClass 
			ORDER BY PostClass
		</cfquery>  
	 
	 </cfcase>
	 
	  <cfcase value="ParentNameShort">
	 
	 	<cfquery name="Graph" 
	    datasource="AppsQuery" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			#preserveSingleQuotes(qry)#
			GROUP BY ParentHierarchyCode, ParentNameShort
			ORDER BY ParentHierarchyCode
		</cfquery>  
			 
	 </cfcase>
	 
	 <cfcase value="OccGroupAcronym">
	 
	 	<cfquery name="Graph" 
	    datasource="AppsQuery" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			#preserveSingleQuotes(qry)#
			GROUP BY OccupationalGroup, OccGroupAcronym
			ORDER BY OccupationalGroup, OccGroupAcronym
		</cfquery>  
		
	 </cfcase>
	 
	  <cfdefaultcase>
	 
	 	<cfquery name="Graph" 
	    datasource="AppsQuery" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			#preserveSingleQuotes(qry)#
			GROUP BY PostGradeBudget, PostOrderBudget
			ORDER BY PostOrderBudget	
		</cfquery>  
	 
	 </cfdefaultcase>

</cfswitch>	

<cfquery name="MaxCount" dbtype="query">
	SELECT MAX(CountedPosition) as total
	FROM Graph
</cfquery>  

<cfif url.print eq "1">
    <cfset h = "700">
	<cfset f = "20">
	<cfset w = "2000">
<cfelse>	
	<cfset h = "340">
	<cfset f = "10">
	<cfset w = client.width-200>
</cfif>

<cfset vColorlist = "##D24D57,##52B3D9,##E08283,##E87E04,##81CFE0,##2ABB9B,##5C97BF,##9B59B6,##E08283,##663399,##4DAF7C,##87D37C">
<cfset vImagePath = "#session.rootpath#\CFRStage\user\#session.acc#\_vacancyGraph">
<cfset vImageURL  = "#session.root#/CFRStage/user/#session.acc#/_vacancyGraph">

<cfif url.format eq "Pie">

	<cfset w = w/2>
	
   	<table cellspacing="0" cellpadding="0"><tr><td>
   
   	  <cfif url.scope eq "all" or url.scope eq "inc">  
	  
		<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
										
		<cfchart style = "#chartStyleFile#" 
			   format          = "png"
	           chartheight     = "#h#"
	           title           = "Encumbered"
	           chartwidth      = "#w#"
	           showxgridlines  = "yes"
	           seriesplacement = "default"
	           labelformat     = "number"
			   fontsize        = "15"
	           yaxistitle      = "Post/Vacancy count"
	           show3d          = "yes"	         
	           pieslicestyle   = "sliced"
	           url             = "javascript:listener('$ITEMLABEL$')">
	
		 <cfchartseries
		      type           = "#url.format#"
		      query          = "Graph"
		      itemcolumn     = "#url.item#"
		      valuecolumn    = "Occupied"
		      serieslabel    = "Encumbered"
			  datalabelstyle = "pattern"
		      seriescolor    = "ffffaf"
		      paintstyle     = "raise"
		      markerstyle    = "circle"
			  colorList		 = "#vColorlist#"/> 
		  
		</cfchart>
		
			
	</cfif>
	
	</td>
	<td>
	
	 <cfif url.scope eq "all" or url.scope eq "vac">  
	 	  	 
	 <cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
	 				 		
		<cfchart style = "#chartStyleFile#" 
	  	  format          = "png"
	      chartheight     = "#h#"
		  title           = "Vacant"
	      chartwidth      = "#w#"
	      showxgridlines  = "yes"
		  fontsize        = "15"
	      seriesplacement = "default"
	      labelformat     = "number"
		  yaxistitle      = "Post/Vacancy count"
	      show3d          = "yes"	      	      
	      url             = "javascript:listener('$ITEMLABEL$')">	  
   
		 <cfchartseries
		      type="#url.format#" query="Graph"
		      itemcolumn="#url.item#"
		      valuecolumn="Vacant"
			  datalabelstyle="pattern"
		      serieslabel="Vacant"
		      seriescolor="03A678"
		      paintstyle="raise"
		      markerstyle="circle"
			  colorList="#vColorlist#"/> 
			  
		</cfchart>	
			
	</cfif>
	
	</td>
	
	</tr></table>   
  
<cfelse>

	<CFIF url.format eq "bar" and url.scope eq "all">
		<cfset st = "value">
	<cfelse>
		<cfset st = "value">	
	</CFIF>

	<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">	
	
	<cfchart style        = "#chartStyleFile#" 
		  format          = "png"
	      chartheight     = "250"
	      chartwidth      = "#client.width-140#"
	      showxgridlines  = "yes"
		  showYGridlines  = "Yes"		
		  fontsize        = "15"
		  ScaleTo         = "#maxcount.total+4#" 
		  gridlines       = "10"
	      seriesplacement = "stacked"
	      labelformat     = "number"		 
	      yaxistitle      = "Post / Vacancy"
	      show3d          = "no" 
	      url             = "javascript:listener('$ITEMLABEL$')">
		  
	 <cfif url.scope eq "all" or url.scope eq "inc">  
	
		 <cfchartseries
		      type           = "#url.format#"
		      query          = "Graph"
		      itemcolumn     = "#url.item#"
		      valuecolumn    = "Occupied"
		      serieslabel    = "Encumbered"	
			  datalabelstyle = "#st#"		 
		      seriescolor    = "5C97BF"
		      paintstyle     = "raise"
		      markerstyle    = "circle"/> 
		  
	</cfif>		
	
	<cfif url.scope eq "all" or url.scope eq "vac">    
	   
		 <cfchartseries
		      type           = "#url.format#" 
			  query          = "Graph"
		      itemcolumn     = "#url.item#"
		      valuecolumn    = "Vacant"
		      serieslabel    = "Vacant"
			  datalabelstyle = "#st#"
			  seriescolor    = "EB974E"
		      paintstyle     = "raise"
		      markerstyle    = "circle"/> 
		  
    </cfif> 	
			
	</cfchart>
	
	<cfset vDefaultValueList = evaluate("Graph.#url.item#")>
	<cfset ajaxonload("function() { listener('#vDefaultValueList#'); }")>
	
</cfif>	

<script>
	Prosis.busy('no')
</script>
