
<cf_dialogREMProgram>

<cfparam name="URL.mode" default="chart">
<cfparam name="URL.show3d" default="No">

<cf_screentop html="No" jquery="Yes">

<!--- two scenarios

1. zero base requires pro-rata target for each measure moment 

2. other : will take target value based on subperiod link --->

<cfparam name="URL.ID" default="{00000000-0000-0000-0000-000000000000}">

<cfquery name="Title" 
	datasource="AppsProgram"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      ProgramIndicator I, 
	          Ref_Indicator R,
			  ProgramPeriod Pe,
			  Program P
	WHERE     I.IndicatorCode = R.IndicatorCode
	AND       Pe.ProgramCode  = I.ProgramCode
	AND       P.ProgramCode   = Pe.ProgramCode
	AND       Pe.Period       = I.Period
	AND 	  TargetId        = '#URL.ID#'   
</cfquery>	

<cfquery name="Current" 
	datasource="AppsProgram"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    MAX(AuditDate) AS AuditDate
	FROM      Ref_Audit 
	WHERE     AuditDate < getDate()
	AND       AuditDate IN (
							SELECT    TOP 1 R.AuditDate
							FROM      ProgramIndicatorAudit M INNER JOIN
							          Ref_Audit R ON M.AuditId = R.AuditId INNER JOIN
							          ProgramIndicator ON M.TargetId = ProgramIndicator.TargetId INNER JOIN
							          Program ON ProgramIndicator.ProgramCode = Program.ProgramCode
							WHERE     M.AuditTargetValue > 0 
							AND       R.AuditDate     < GETDATE() 
							AND       R.Period        = '#URL.Period#'
							AND       Program.Mission = '#Title.Mission#'
							ORDER BY R.AuditDate DESC
						   )
	AND       Period = '#URL.Period#' 
</cfquery>

<cfoutput>

	<script language="JavaScript">	
	
	    function reload(mde,dim) {
			 ptoken.location("IndicatorAuditGraph.cfm?h=#url.h#&period=#url.period#&id=#URL.ID#&mode="+mde+"&show3d="+dim)
		}
		
		function more(lbl,dr) {		
						
			if (dr == "0") { 
			    alert("Sorry, no drill down available.")
			} else {
				if (lbl != '') {			
			        w = #CLIENT.width# - 10;
			        h = #CLIENT.height# - 80;						
					window.open("../Details/DetailView.cfm?Period=#URL.Period#&TargetId=#URL.ID#&Date="+lbl, "#Title.IndicatorCode#" , "left=50, top=50, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes")												
				}
			}			
		}
			
		function drill(lbl) {
		
			if (lbl != '') {			
		        w = #CLIENT.width# - 10;
		        h = #CLIENT.height# - 80;
				ptoken.open("../Details/DetailView.cfm?Period=#URL.Period#&TargetId=#URL.ID#&Auditid="+lbl, "#Title.IndicatorCode#" , "left=50, top=50, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes") 
			}	
			
 		 }		
	  
	</script>
	
</cfoutput>

<cfquery name="Parameter" 
datasource="AppsProgram"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterMission
	WHERE     Mission = '#Title.Mission#'
</cfquery>	

<cfif Title.IndicatorType eq "0001">
 <cfset format = "number">
<cfelse>
 <cfset format = "percent">
</cfif>

<cfif Title.ZeroBase eq "1">
 <cfset field = "TargetValueZeroBase">
<cfelse>
 <cfset field = "TargetValue">
</cfif>

<cfif Title.IndicatorType eq "0001">

<cfswitch expression="#title.IndicatorPrecision#">
	<cfcase value="0">
		<cfset f = "__,__">
	</cfcase>
	<cfcase value="1">
		<cfset f = "__,__._">
	</cfcase>
	<cfcase value="2">
		<cfset f = "__,__.__">
	</cfcase>
	<cfdefaultcase>
	<cfset f = "__,__">
	</cfdefaultcase>
</cfswitch>

<cfelse>
	<cfset f = "__">
</cfif>

<cfquery name="Target" 
datasource="AppsProgram"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   LEFT(DATENAME(Mm, A.AuditDate), 3) + ' ' + RIGHT(DATENAME(Yy, A.AuditDate), 2) AS AuditDateName, 
             I.TargetValue * A.ZeroBaseRatio AS TargetValueZeroBase, I.TargetValue AS TargetValue
	FROM     Ref_Audit A INNER JOIN
             ProgramIndicatorTarget I ON A.SubPeriod = I.SubPeriod
	WHERE    (A.Period = '#URL.Period#') AND (I.TargetId = '#URL.ID#')
	AND      A.AuditDate <= '#dateformat(current.auditDate,client.dateSQL)#' 
	ORDER BY A.DateYear, A.DateMonth
</cfquery>

<cfquery name="Source" 
datasource="AppsProgram"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   Source
	FROM     Ref_IndicatorSource
	WHERE    IndicatorCode = '#Title.IndicatorCode#' 
	ORDER BY ListingOrder
</cfquery>	

<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">

<tr><td>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr height="10" class="line" style="border-top:1px solid silver">
	<td width="98%" height="24" class="labellarge" style="padding-left:14px"><cf_tl id="Measurements"></td>
<cfoutput>
    
	<td align="right">
	   	<button type="button" name="List" style="height:20;width:20" onclick="reload('list')" class="button3" value="List">
			<img src="#SESSION.root#/Images/list.gif" alt="" border="0">
		</button>
	</td>
	
	<cfquery name="Audit" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Audit
	WHERE    Period = '#URL.Period#'
	AND      AuditDate < getDate()
	ORDER BY AuditDate DESC
	</cfquery>
		
	<cfif Title.IndicatorDrillDown eq "1">
		<td>
			<button type="button" name="Drill" style="height:20;width:20" onclick="javascript:drill('#Audit.AuditId#')" class="button3" value="Graph">
			<img src="#SESSION.root#/Images/drilldown.gif" alt="" border="0">
			</button>
		</td>		
	</cfif>
	<cfif url.mode eq "Chart">
		<td>
			<button type="button" name="Graph" style="height:20;width:20" onclick="reload('chart','no')" class="button3" value="Graph">
			<img src="#SESSION.root#/Images/chart_2d.gif" width="22" height="20" alt="" border="0">
			</button>
		</td>	
		<!---
		<td>
			<button type="button" name="Graph" style="height:20;width:30" onclick="reload('chart','yes')" class="button3" value="Graph">
			<img src="#SESSION.root#/Images/chart_3d.gif" width="22" height="18" alt="" border="0">
			</button>
		</td>		
		--->
	<cfelse>
		<td>
			<button type="button" name="Graph" style="height:20;width:20" onclick="reload('chart','no')" class="button3" value="Graph">
			<img src="#SESSION.root#/Images/chart.gif" alt="" border="0">
			</button>
		</td>	
	</cfif>	
			
</tr>		
</cfoutput>    
</table>  
</td></tr>

<cfif url.mode eq "Chart">

	<cfoutput query="Source">
	
		<cfquery name="#source#" 
		datasource="AppsProgram"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		
		SELECT     LEFT(DATENAME(Mm, A.AuditDate), 3) + ' ' + RIGHT(DATENAME(Yy, A.AuditDate), 2) AS AuditDateName, A.AuditDate, P.AuditTargetValue
		FROM       ProgramIndicatorTarget I RIGHT OUTER JOIN
	               ProgramIndicatorAudit P ON I.TargetId = P.TargetId AND I.TargetId = '#URL.ID#' RIGHT OUTER JOIN
	               Ref_Audit A ON I.SubPeriod = A.SubPeriod AND P.AuditId = A.AuditId AND P.Source = '#source#' AND P.AuditStatus <> '0'
		WHERE      A.Period = '#URL.Period#'
		AND        A.AuditDate <= '#dateformat(current.auditDate,client.dateSQL)#'
		GROUP BY   A.AuditDate, P.AuditTargetValue
		HAVING     P.AuditTargetValue IS NOT NULL
		UNION
		SELECT     LEFT(DATENAME(Mm, A.AuditDate), 3) + ' ' + RIGHT(DATENAME(Yy, A.AuditDate), 2) AS AuditDateName, A.AuditDate, 0 AS AuditTargetValue
		FROM       ProgramIndicatorTarget I RIGHT OUTER JOIN
		           ProgramIndicatorAudit P ON I.TargetId = P.TargetId AND I.TargetId = '#URL.ID#' RIGHT OUTER JOIN
		           Ref_Audit A ON I.SubPeriod = A.SubPeriod AND P.AuditId = A.AuditId AND P.Source = '#source#' AND P.AuditStatus <> '0'
		WHERE      A.Period = '#URL.Period#'
		AND        A.AuditDate <= '#dateformat(current.auditDate,client.dateSQL)#'
		GROUP BY   A.AuditDate, P.AuditTargetValue
		HAVING     P.AuditTargetValue IS NULL
		ORDER BY A.AuditDate
					
		</cfquery>
		
	</cfoutput>
	
	<tr><td align="center">
	
		  <cfif CLIENT.width gt "1024">
		      <cfset w = CLIENT.widthfull - 440>
		  <cfelse>
		      <cfset w = CLIENT.widthfull - 440> 
		  </cfif> 
		  
		 <cftry>	
		 
		  <cfif Title.ChartScaleFrom eq "">
		   <cfset from = 0>
		  <cfelse>
		   <cfset from =  Title.ChartScaleFrom> 
		  </cfif>	
		  
		  <cfif Title.ChartLines eq "">
		   <cfset line = 1>
		  <cfelse>
		   <cfset line =  Title.ChartLines> 
		  </cfif>		  
		
		  <cfchart
	       format         = "png"
	       chartheight    = "#url.h-10#"
	       chartwidth     = "#w#"
		   scalefrom      = "#from#" 
		   scaleto        = "#Title.ChartScaleTo#"
		   gridlines      = "#line#"
	       showygridlines = "yes"
		   seriesplacement= "cluster"
	       labelformat    = "#format#"
		   showlegend     = "yes"
	       fontsize       = "10"
		   show3d         = "#url.show3d#"
		   font           = "Arial"
		   url            = "javascript:more('$ITEMLABEL$','#Title.IndicatorDrillDown#')"
		   tipstyle       = "mouseOver"
	       tipbgcolor     = "E9E9D1"
		   showxgridlines = "yes"
	       sortxaxis      = "no">
		   
		   <cfif Title.ChartColorTarget neq "">
				<cfset c = Title.ChartColorTarget>
 		   <cfelse>
			    <cfset c = "green">					
		   </cfif>	
				   
		   <cfchartseries
	             type        = "#Title.ChartType#"
	             query       = "Target"
	             itemcolumn  = "AuditDateName"
	             valuecolumn = "#field#"
	             serieslabel = "#Parameter.IndicatorLabelTarget#"
	             paintstyle  = "light"
				 seriescolor = "#c#"
	             markerstyle = "triangle">
		   </cfchartseries> 
			
		   <cfloop query="Source">
			
			   <cfif Source eq "Manual">
				   
			   		 <cfif Title.ChartColorManual neq "">
					       <cfset c = Title.ChartColorManual>
		  			 <cfelse>
						   <cfset c = "gray">					
					 </cfif>	
					   
					 <cfif Source.recordcount eq "1">
						   <cfset t = Parameter.IndicatorLabelManual>
					 <cfelse>
						   <cfset t = Parameter.IndicatorLabelManual>
					 </cfif>
					  
			   <cfelse>
				   
			   		 <cfif Title.ChartColorUpload neq "">
					      <cfset c = Title.ChartColorUpload>
		  			 <cfelse>
						  <cfset c = Parameter.ProgramColorActual>			
					 </cfif>	
					 <cfset t = Source>
					  
			   </cfif>
		
			   <cfchartseries
	             type="#Title.ChartType#"
	             query="#source.source#"
	             itemcolumn="AuditDateName"
	             valuecolumn="AuditTargetValue"
				 seriescolor="#c#"
	             serieslabel="#t#"
	             paintstyle="light"
	             markerstyle="triangle"></cfchartseries>
			
			</cfloop>	
			
			</cfchart>	 
		 
		 <cfcatch>
	
		      <cfchart
		       format         = "png"
		       chartheight    = "#url.h-10#"
		       chartwidth     = "#w#"		 
		       showygridlines = "yes"
		       seriesplacement= "cluster"
		       labelformat    = "#format#"
			   showlegend     = "yes"
		       fontsize       = "10"
			   show3d         = "#url.show3d#"
			   font           = "Arial"
			   url            = "javascript:more('$ITEMLABEL$','#Title.IndicatorDrillDown#')"
			   tipstyle       = "mouseOver"
		       tipbgcolor     = "E9E9D1"
			   showxgridlines = "yes"
		       sortxaxis      = "no">
					   
			   <cfchartseries
		             type        = "#Title.ChartType#"
		             query       = "Target"
		             itemcolumn  = "AuditDateName"
		             valuecolumn = "#field#"
		             serieslabel = "#Parameter.IndicatorLabelTarget#"
		             paintstyle  = "light"
					 seriescolor = "green"
		             markerstyle = "triangle">
			   </cfchartseries> 
				
			   <cfloop query="Source">
				
				   <cfif Source eq "Manual">
				   
				   		 <cfif Title.ChartColorManual neq "">
						       <cfset c = Title.ChartColorManual>
			  			 <cfelse>
							   <cfset c = "gray">					
						 </cfif>	
						   
						 <cfif Source.recordcount eq "1">
							   <cfset t = Parameter.IndicatorLabelManual>
						 <cfelse>
							   <cfset t = Parameter.IndicatorLabelManual>
						 </cfif>
					  
				   <cfelse>
				   
				   		 <cfif Title.ChartColorUpload neq "">
						      <cfset c = Title.ChartColorUpload>
			  			 <cfelse>
							  <cfset c = Parameter.ProgramColorActual>			
						 </cfif>	
						 <cfset t = Source>
					  
				   </cfif>
			
				   <cfchartseries
		             type="#Title.ChartType#"
		             query="#source.source#"
		             itemcolumn="AuditDateName"
		             valuecolumn="AuditTargetValue"
					 seriescolor="#c#"
		             serieslabel="#t#"
		             paintstyle="light"
		             markerstyle="circle"></cfchartseries>
				
				</cfloop>
					 
			</cfchart>
		
		</cfcatch>
		
		</cftry>
		
	</td></tr>

<cfelse>

<tr><td valign="top" height="100%">

	<cfif CLIENT.width gt "1024">
      <cfset w = CLIENT.width - 340>
  	<cfelse>
      <cfset w = CLIENT.width - 340> 
	</cfif>  
	
	<cf_divscroll>
	
	<table align="center" width="97%" border="0" cellspacing="0" border="0" cellpadding="0" class="formpadding">
	
	<tr class="line">
		<td></td>
		<cfoutput query="Target">
		<td align="center" height="35">
			<a href="javascript:more('#AuditDateName#')" title="Drill down">#AuditDateName#</a>
		</td>	
		</cfoutput>
	</tr>
	
	<tr bgcolor="ffffcf" class="line">
		<td width="70" class="labelit"><cf_tl id="Target"></td>
		<cfoutput query="Target">
		<td height="35" align="center" class="labelit">
		    <cfif field eq "">
			<cfelse>
			    <cfif Title.IndicatorType eq "0002">			
				#numberFormat("#evaluate(field)*100#","#f#")#%
				<cfelse>
				#numberFormat("#evaluate(field)#","#f#")#
			</cfif>
			</cfif>
		</td>
		</cfoutput>
	</tr>
	
	<cfoutput query="Source">
			
		 <cfif Source eq "Manual">
		 
		       <cfif Title.ChartColorManual neq "">
			       <cfset c = Title.ChartColorManual>
  			   <cfelse>
				    <cfset c = "gray">					
			   </cfif>	
			   
			   <cfif Source.recordcount eq "1">
				   <cfset t = Parameter.IndicatorLabelManual>
			   <cfelse>
				   <cfset t = Parameter.IndicatorLabelManual>
			   </cfif>
					
		  <cfelse>
		  
		  	 <cfif Title.ChartColorUpload neq "">
			      <cfset c = Title.ChartColorUpload>
  			 <cfelse>
				  <cfset c = Parameter.ProgramColorActual>			
			  </cfif>	
			  <cfset t = Source>
			  
		 </cfif>
	
		<cfquery name="#source#" 
		datasource="AppsProgram"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		
			SELECT   left(DateName(Mm, A.AuditDate),3)+' '+right(DateName(Yy, A.AuditDate),2) as AuditDateName, 
					 P.AuditTargetValue
			FROM     ProgramIndicatorTarget I RIGHT OUTER JOIN
	                 ProgramIndicatorAudit P ON I.TargetId = P.TargetId 
					           AND I.TargetId = '#URL.ID#' RIGHT OUTER JOIN
	                 Ref_Audit A ON I.SubPeriod = A.SubPeriod 
					           AND P.AuditId = A.AuditId 
							   AND P.Source = '#source#' 
							   AND P.AuditStatus <> '0'
			WHERE    A.Period = '#URL.Period#'				
			AND      A.AuditDate <= '#dateformat(current.auditDate,client.dateSQL)#'
			ORDER BY A.DateYear, A.DateMonth 
				
		</cfquery>
			
	<tr class="line">
		<td class="labelit"><font color="#c#"></font>#t#</td>
		<cfloop query="#source#">
		<td height="33" class="labelit" align="center">
		    <font color="#c#">
		    <cfif auditTargetvalue neq "">
				<cfif Title.IndicatorType eq "0002">
					#numberFormat("#auditTargetvalue*100#","#f#")#%
				<cfelse>
					#numberFormat("#auditTargetvalue#","#f#")#
				</cfif>			
			<cfelse>
			 -   
			</cfif>
			</font>
		</td>
		</cfloop>
	</tr>

	</cfoutput>
	
	</table>
	
	</cf_divscroll>
	
</td></tr>

</cfif>
</table>


