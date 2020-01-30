
<!---
<cfoutput>#cgi.query_string#</cfoutput>
--->
 
	  
<cfparam name="url.drillfield" default=""> 

<cfset pos = find("drillfield",cgi.query_string)>
<cfset str = left(cgi.query_string,pos-1)>

<table width="100%" border="1" bgcolor="BFE7F2">

<tr bgcolor="BFE7F2">

<td style="min-height:40px;width:100%">			

<cfoutput>

	  <cfquery name="fields" 
				datasource="appsSystem">
				SELECT  OutputId
				FROM     UserPivot
			    WHERE    ControlId = '#URL.ControlId#'					
   	  </cfquery>
				
	  <cfquery name="fields" 
				datasource="appsSystem">
				SELECT  DISTINCT OutputHeader
				FROM     UserReportOutput
			    WHERE    OutputId IN (SELECT  OutputId
									  FROM     UserPivot
									  WHERE    ControlId = '#URL.ControlId#'
									  )
				AND      FieldName LIKE '%_dim'	
				AND      FieldName NOT IN (SELECT U.FieldName
											FROM   UserPivotDetail U INNER JOIN
								                   UserPivot UP ON U.ControlId = UP.ControlId
											WHERE  UP.ControlId = '#url.controlid#'		
											AND    UP.Node = '#url.node#'	
											AND    UP.Account = '#SESSION.acc#'
											AND    U.Presentation != 'Drilldown'									
										  )	
	  </cfquery>
			  	
	  <select id="drillfield_#node#_#cellid#" name="drillfield_#node#_#cellid#"
        class="regularxl" style="border:0px;background-color:transparent"			
        onChange="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/Tools/CFReport/Analysis/CrossTab_ColExpand.cfm?#str#&drillfield='+this.value,'#node#_#cellid#')">				   
			<cfloop query="fields">
				<option value="#OutputHeader#" <cfif url.drillfield eq outputheader>selected</cfif>>#OutputHeader#</option>
			</cfloop>		
   	  </select>
	  	  
	
	<td style="min-width:30px" align="center" onclick="drillgraph('#node#_#cellid#')">
		<img src="#SESSION.root#/Images/expand.png" height="20" id="#node#_#cellid#_exp" alt="Show Graph" align="absmiddle" class="regular">			 
		<img src="#SESSION.root#/Images/collapse.png" height="20" class="hide" id="#node#_#cellid#_col" align="absmiddle">			 
	</td>

</td>

</cfoutput>	
		
</td></tr>

<cfif url.drillfield neq "">

<tr><td colspan="2">			

<!---	
		
		<cfoutput>
		node:<b>#url.node#</b>
		group:<b>#url.group#</b>
		box:<b>#url.box#</b>
		mode:<b>#url.mde#</b><br>
		grp1name:<b>#url.grp1nme#</b>
		group1:<b>#url.group1#</b><br>
		grp2name:<b>#url.grp2nme#</b>
		group2:<b>#url.group2#</b><br>
		yax:<b>#url.yax#</b>
		yaxval:<b>#url.yaxval#</b><br>
		xax:<b>#url.xax#</b>
		xaxval:<b>#url.xaxval#</b>
		#drill.recordcount#----
		</cfoutput>
		</tr>
			
	--->
				<!--- template to show expand cols, the sequence is as follows
		Define the undelrying data in the table
		Define the correct field values to select out of th table
		Define the formula for the selection
		Define the col values relevant in the column
		Extract the data and output (HTML) the data
	--->
		

<cfparam name="url.drillfield" default="Location">

<cfset field_name  = "#url.drillfield#_dim">
<cfset field_label = "#url.drillfield#_dim">
<cfset field_order = "#url.drillfield#_dim">

<cfquery name="SystemParam" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      Parameter
</cfquery>
		
<cfset aut_server = "#SystemParam.AuthorizationServer#">

<!--- determine the underlying table --->

<cfquery name="Table"
    datasource="AppsSystem">
		SELECT   *
		FROM     UserPivot
		WHERE    ControlId = '#url.controlId#'
		AND      Node = '#url.node#' 
</cfquery>

<cfset sel = "">

<!--- define the fields available for the dimension --->

<cfquery name="fields" 
	datasource="#Table.DataSource#">
	SELECT   C.name, 
	         C.usertype, 
			 systypes.name AS fieldtype, 
			 C.length
	FROM     sysobjects S INNER JOIN
             syscolumns C ON S.id = C.id INNER JOIN
             systypes ON C.xtype = systypes.xtype
    WHERE    S.id = C.id
	AND      S.name = '#Table.TableName#_summary'
	AND      C.UserType NOT IN ('0','20','3','19','4')  
	AND      C.name = '#url.drillfield#_nme'
    ORDER BY C.colid  
</cfquery>

<cfif fields.recordcount eq "1">
 	<cfset field_label = "#url.drillfield#_nme">	
</cfif>

<cfquery name="fields" 
	datasource="#Table.DataSource#">
	SELECT   C.name, 
	         C.usertype, 
			 systypes.name AS fieldtype, 
			 C.length
	FROM     sysobjects S INNER JOIN
             syscolumns C ON S.id = C.id INNER JOIN
             systypes ON C.xtype = systypes.xtype
    WHERE    S.id = C.id
	AND      S.name = '#Table.TableName#_summary'
	AND      C.UserType NOT IN ('0','20','3','19','4')  
	AND      C.name = '#url.drillfield#_ord'
    ORDER BY C.colid  
</cfquery>

<cfif fields.recordcount eq "1">
 	<cfset field_order = "#url.drillfield#_ord">
</cfif>

<!--- load formula into memory --->

<cfquery name="Formula" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM      UserPivotDetail
	WHERE     ControlId = '#ControlId#' 
	AND       Presentation = '#url.formula#' 
	ORDER BY  PresentationOrder
</cfquery>

<cfloop query="Formula">

	<cfif FieldValue eq "Count">
			<cfset for  = "'#FieldValue#' as Drill#currentRow#,#FieldName# as DrillValue#currentRow#, cast(0 as float) as Drill#currentrow#Total, '#FieldDataType#' as Drill#currentRow#Format">					
	<cfelseif FieldValue eq "Distinct">		
			<cfset for  = "'#FieldValue#' as Drill#currentRow#,COUNT (#FieldName#) as DrillValue#currentRow#, cast(0 as float) as Drill#currentrow#Total, '#FieldDataType#' as Drill#currentRow#Format">						
	<cfelseif FieldValue eq "AVG" or FieldValue eq "STDEV" or FieldValue eq "VAR">	
			<cfset for  = "'#FieldValue#' as Drill#currentRow#,#FieldName# as DrillValue#currentRow#, cast(0 as float) as Drill#currentrow#Total, '#FieldDataType#' as Drill#currentRow#Format">								
	<cfelse>		
			<cfset for  = "'#FieldValue#' as Drill#currentRow#,#FieldName# as DrillValue#currentRow#, cast(0 as float) as Drill#currentrow#Total, '#FieldDataType#' as Drill#currentRow#Format">						   		
	</cfif>
	
    <cfset sel   = "#sel#, #for#"> 		
	
</cfloop>	


<!--- --create X-ax values for easy comparison among selection--- --->

<!--- ----------------------------------------------------------- --->
<!--- Pending filter this by selected column already year/month)- --->
<!--- ----------------------------------------------------------- --->
	
<!--- ------------------Generate dimension----------------------- --->

<cfinvoke component="Service.Analysis.CrossTab"  
	  method="GenerateDimension"
	  ControlId            = "#url.controlid#"
	  Dimension            = "DrillDown"
	  factalias            = "#Table.DataSource#"
	  facttable            = "dbo.#Table.TableName#_summary"
	  alias                = "#Table.DataSource#"
	  table                = "dbo.#Table.TableName#_summary T"			 
	  FieldName            = "#field_name#"
	  FieldValue           = "#field_name#"
	  FieldWidth           = "30"
	  FieldTooltip         = "#field_label#"
	  FieldListingOrder    = "#field_order#"
	  FieldHeader          = "#field_label#"
	  FieldDataType        = "varchar">
	  
<!--- demension labels ---> 	

<CF_DropTable dbName="#Table.DataSource#" tblName="#SESSION.acc#_#node#_CrossTabDataDimension">	 
	  
<cfquery name="CreateDrillLabel" 
	datasource="#Table.DataSource#">
		SELECT   Presentation,
		         FieldValue,		
				 FieldHeader,	
				 MAX(Listingorder) as ListingOrder
		INTO     dbo.#SESSION.acc#_#node#_CrossTabDataDimension
		FROM     [#aut_server#].System.dbo.UserPivotDetail
		WHERE    ControlId    = '#URL.ControlId#' 
		AND      Presentation = 'DrillDown'			
		GROUP BY Presentation,FieldValue, FieldHeader	
</cfquery>	
 
<cfquery name="DrillLabel" 
	datasource="#Table.DataSource#">
		SELECT   *	
		FROM     #SESSION.acc#_#node#_CrossTabDataDimension
		<cfif url.xax neq "" and url.xaxval neq "">
		WHERE    FieldValue IN (SELECT #field_name#
		                        FROM   dbo.#Table.TableName#_summary
								WHERE  #url.xax# = '#url.xaxval#'
								) 
		</cfif>						
		ORDER BY ListingOrder	
</cfquery>				  

<!--- Hanno : link the tables to pass the value of the dimension and then save the content into an array --->
  
<cfoutput>	
							
		<cfquery name="Drill"
		    datasource="#Table.DataSource#">
				SELECT  #field_label# as Label,
				        Ref.ListingOrder
				        <cfif field_label neq field_order>, #field_Order# as Ordered</cfif>, 
					    #preservesinglequotes(for)# 	      
				FROM    dbo.#Table.TableName#_summary Base,
						dbo.#SESSION.acc#_#node#_CrossTabDataDimension Ref
				WHERE   Ref.FieldValue = Base.#field_name#
				<cfif url.grp1nme neq "" and url.group1 neq "">
				AND    #url.grp1nme# = '#url.group1#'
				</cfif>
				<cfif url.grp2nme neq "" and url.group2 neq "">
				AND    #url.grp2nme# = '#url.group2#'
				</cfif>
				<!--- 
				<cfif url.grp3nme neq "">
					AND #url.grp3nme# = '#url.group3#'
				</cfif>	
				--->	
				<cfif url.yax neq "" and url.yaxval neq "">
				AND    #url.yax# = '#url.yaxval#'
				</cfif>
				<cfif url.xax neq "" and url.xaxval neq "">
				AND    #url.xax# = '#url.xaxval#'
				</cfif>			
				GROUP BY #field_label#, Ref.ListingOrder <cfif field_label neq field_order>, #field_Order# </cfif>
				ORDER BY #field_Order#	
		</cfquery>	
							
		<table width="100%"	      
	       bgcolor="E4F3FC"		   
	       class="formpadding">					
						
			<tr class="labelmedium">		
			
			<cfset det=ArrayNew(2)>
			
			<cfset base = 0>
			
			<!--- set the values --->
			
			<cfloop index="F" from="1" to="#formula.recordcount#">
			
				<cfloop query="Drill">
				
					<cfset det[listingOrder][F] = evaluate("DrillValue#F#")>	
					<cfset base = base+	det[listingOrder][F]>	
					
				</cfloop>
				
			</cfloop>		
			
			<cfloop query="drilllabel">
			
				<cfparam name="det[ListingOrder][1]" default="">
			
				<cfif det[ListingOrder][1] neq "">
				
				    <!--- reload content --->
					<td valign="top" align="center" onclick="document.getElementById('drill_#node#_#cellid#').click()"
					    style="font-size:10px;border-right:1px solid silver;height:60px;word-wrap: break-word; word-break: break-all;">										
						#fieldheader#					
					</td>
				
				</cfif>
				
				
			</cfloop>
			
			</tr>								
			
			<tr>									
			
			<cfloop query="drilllabel">
											
				<cfif det[ListingOrder][1] neq "">
				
					<td valign="top" align="right" bgcolor="white" class="cell">					
					
					<cf_CrossTab_Cell size="20" 
						   tpe="#formula.fieldDataType#" 
						   val="#det[ListingOrder][1]#" 
						   base="#base#">
						   
					</td>	
					
				</cfif>	   
														
			</cfloop>	
				
			</tr>	
			
			<tr bgcolor="white" class="hide" id="#node#_#cellid#_graph">
			
			<td colspan="#drilllabel.recordcount#" align="center">
			
			<cfset w = drilllabel.recordcount*64>
			
			<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">

				<cfchart style = "#chartStyleFile#" format="png"
		           chartwidth="#w#"
		           seriesplacement="default"
		           font="Calibri"
		           fontsize="9"
		           labelformat="number"
		           show3d="no"		          
		           tipstyle="mouseOver"
		           pieslicestyle="sliced">
				   
			   <cfchartseries type="bar" colorlist="##e4e4e4">
			   
			   	   <cfloop query="drilllabel">
				   
					   <cfif det[ListingOrder][1] neq "">
				   												
						  <cfset val = 	det[ListingOrder][1]>													  				 
					      <cfchartdata item="#fieldheader#" value="#val#"/>
						  
					   </cfif>				   	  
					 
				   </cfloop> 
			   
			   </cfchartseries>
		   
		   </cfchart>
			
			</td>
			</tr>
								
</table>

</cfoutput>

</td></tr>

</cfif>

</table>	
	
	