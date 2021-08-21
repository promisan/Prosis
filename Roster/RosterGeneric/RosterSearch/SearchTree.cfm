
<cf_screentop label="Archive" height="100%" html="No" band="No" scroll="Yes" jquery="Yes">

<cfparam name="url.id1" default="0">

<cfif URL.docNo neq "">
	
	<cfquery name="Criteria" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   RosterSearchLine
	  WHERE  SearchId = '#URL.ID1#' 
	</cfquery>
	
	<cfif Criteria.recordcount eq "0" and url.mode neq "vacancy" and url.mode neq "ssa">
	
		   <cfabort>
	
	</cfif>

</cfif>

<cfoutput>
			
	<script>
		
		function opennew(mde,own,sta,doc) {		
			 ptoken.open('Search1.cfm?mode='+mde+'&docno='+doc+'&status='+sta+'&owner='+own,'main')
		}	 
		
		 function openme(mde,doc,id) {
			 ptoken.open('ResultView.cfm?mode='+mde+'&docno='+doc+'&ID='+id,'main')
		}	
	 
	</script>

</cfoutput>

<cf_dialogPosition>

<table width="100%" height="100%"><tr><td style="width:100%;height:100%" valign="top">

<cfform>

	<table width="100%" align="center" class="formpadding">
	
	<tr><td height="10"></td></tr>
	<tr><td style="padding-left:9px">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<cfparam name="URL.Mode" default="0">
		<cfparam name="URL.DocNo" default="">
		
		<cfif URL.docNo eq "">
			
			<cfif URL.ID eq "0"> 
		
			<tr><td class="labelit">
			<cfoutput>
			<img src="#SESSION.root#/Images/point.jpg" alt="" border="0">&nbsp;
				<a id="newsearch" href="javascript:opennew('#URL.Mode#','#URL.Owner#','#URL.Status#','#URL.DocNo#')"><cf_tl id="New search"></a>
			</td></tr>
			</cfoutput>
			
			<tr><td height="5" class="Show"></td></tr>	
			<tr><td height="1" class="line"></td></tr>
			<tr><td height="5" class="Show"></td></tr>	
			
			<cfelse>
			
			<cfparam name="URL.ID" default="1">	
				
			<tr><td class="labelmedium" style="padding-left:4px">
			<table><tr><td>
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/point.jpg" alt="Archive result set" border="0">
			</td><td class="labelmedium" style="padding-left:7px">
			<a href="ResultArchive.cfm?id=<cfoutput>#url.id1#&Mode=#URL.Mode#&Owner=#URL.Owner#&Status=#URL.Status#&DocNo=#URL.DocNo#</cfoutput>" target="center"> 
			     <cf_tl id="Archive this result"></a>
			</tr></td>
			</table> 
				 </td></tr>
			
			<tr><td height="1" class="line"></td></tr>
				
			<cfoutput>
			<tr><td class="labelmedium">
			<table><tr><td>
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/overview.gif" alt="" border="0"></td><td class="labelmedium" style="padding-left:7px">
			<a href="Summary/Index.cfm?mode=#url.mode#&docno=#url.docno#&ID1=#URL.ID1#" title="graphical summary" target="center">Summary</a>
				</td></tr></table> 
				 </td></tr>
			</cfoutput>	
			
			<tr><td height="1" class="line"></td></tr>
				
			</cfif>
			
		<cfelse>
		
		    <tr><td align="left" class="labelmedium">Reference <cfoutput><cfif len(url.docno) lte 6>:#URL.docNo#</cfif></cfoutput></td></tr>		
			<tr><td height="1" class="line"></td></tr>	
			
			<cfif URL.ID eq "1"> 
			
			<cfoutput>
			<tr><td class="labelmedium">
			<table><tr><td>
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/overview.gif" alt="" border="0"></td><td class="labelmedium" style="font-size:16px;padding-left:7px">
			<a href="Summary/Index.cfm?mode=#url.mode#&docno=#url.docno#&ID1=#URL.ID1#" title="graphical summary" target="center"><cf_tl id="Summary"></a>
				</td></tr></table> 
				 </td></tr>
			</cfoutput>	
			
			</cfif>
		
		</cfif>
		
		<tr><td>
		
		<cfif URL.ID eq "1"> 
		
			<cf_RosterTreeData>
					
		<cfelse>
		
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			<tr><td colspan="1" class="labelit"><cf_tl id="Search Archive">:</td></tr>
				
			<script>
			
			function more(box,val,doc,mode) {
			   ptoken.navigate('SearchTreeList.cfm?mode='+mode+'&docno='+doc+'&val='+val,box)  
			}	
					
			</script>
			
			<tr>
			 <td bgcolor="white" style="padding-right:4px;border: 0px solid Silver;">	
			 
			 	<cfoutput>
			 
					 <input type     = "text"
					       name      = "find"
				    	   size      = "14"
						   value     = ""
						   onClick   = "this.value=''" 
						   onKeyUp   = "more('search',this.value,'#url.docNo#','#url.mode#')"
					       maxlength = "20"
					       class     = "regularxl">
				 		
				</cfoutput>  
				
			  </td> 	   
				      
			</tr>
			
			<tr><td colspan="1">
			
				<cfdiv id="search">
									
					<cfquery name="List" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						  SELECT   TOP 20 R.*, 
						           D.FunctionalTitle, 
								   D.DocumentNo
						  FROM     RosterSearch R LEFT OUTER JOIN
						           Vacancy.dbo.Document D ON R.SearchCategoryId = D.DocumentNo
						  WHERE    R.SearchCategory = 'Vacancy'
						  AND      R.OfficerUserId = '#SESSION.acc#' 
						  <!--- has results --->
						  AND      R.Searchid IN (SELECT SearchId FROM RosterSearchResult WHERE SearchId = R.SearchId)
						  AND      R.RosterStatus = 1
						  AND      R.Created > getdate()-360
						  ORDER BY R.Created DESC
					</cfquery>
					
					<cfif url.docNo neq "">
					 <cfset tg = "main">
					<cfelse>
					 <cfset tg = "main"> 
					</cfif>
					
					<cfset prior = "">
					
					<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
					<tr><td colspan="2" class="labelit" height="20">Recent Recruitment searches</td></tr>
					
					<cfoutput query="List">
					
						<cfif Dateformat(created,CLIENT.DateFormatShow) neq prior>
						<cfset prior = Dateformat(created,CLIENT.DateFormatShow)> 
						<tr><td class="labelmedium">#Dateformat(created,CLIENT.DateFormatShow)#</td></tr>
						</cfif>
						
						<tr class="linedotted navigation_row">
						<cfif FunctionalTitle neq "">
							<td>
							<table width="100%" cellspacing="0" cellpadding="0">
								<tr>
								<td class="labelit" style="padding-left:10px">							
									  #Dateformat(created,"HH:MM")# <a href="javascript:openme('#url.mode#','#url.docno#','#SearchId#')">#left(FunctionalTitle,20)#.. </a> 
								</td>
								<td align="right" class="labelit" style="padding-right:15px">
									<a href="javascript:showdocument('#documentno#')">#DocumentNo#</a></td>
								</tr>
							</table>
						<cfelse>
							<td class="labelit"><a href="javascript:openme('#url.mode#','#url.docno#','#SearchId#')">#Dateformat(created,CLIENT.DateFormatShow)# #Dateformat(created,"HH:MM")# <font color="0080FF">#Description#</a></td>
						</cfif>			
						</tr>
					
					</cfoutput>
					</table>
				
				</cfdiv>
				
			</td></tr>
			</table>
		
		</cfif>	
			
		</td></tr>
		
		</table>
	
	</td></tr>
	
	</table>

</cfform>

</td>
</tr>
</table>

<cfset ajaxonload("doHighlight")>
	