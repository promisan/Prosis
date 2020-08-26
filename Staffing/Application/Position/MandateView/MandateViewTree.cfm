
<cfparam name="URL.Mission"          default="New">
<cfparam name="URL.Mandate"          default="">
<cfparam name="AccessStaffing"       default="NONE">
<cfparam name="URL.SystemFunctionId" default="">

<cfif URL.Mandate eq "">

	<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	maxrows=1 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Mandate
		WHERE    Mission = '#url.Mission#'
		ORDER BY MandateDefault DESC, MandateNo DESC
	</cfquery>
	  
	<cfset MandateDefault = Mandate.MandateNo>	

<cfelse>

	<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Mandate
		WHERE  Mission = '#url.Mission#'
		AND    MandateNo = '#URL.Mandate#'
	</cfquery>

	<cfset MandateDefault = "#URL.Mandate#">	

</cfif>

<cfset url.mandate = mandatedefault>

<cf_calendarscript>

<cfoutput>

	<script language="JavaScript1.2">
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	w = 0
	h = 0
	if (screen) {
		w = #CLIENT.width# - 40
		h = #CLIENT.height# - 100
	}
	
	function returnMain() {
	    parent.window.close();
	}
	
	function reloadTree(man) {    
	    ptoken.navigate('MandateViewTree.cfm?Mission=#URL.Mission#&Mandate='+man,'treebox')	
	}
	
	function filter() {
	    parent.right.location = "MandateFilter.cfm?Mission=#URL.Mission#"
	}
	
	function period() {
	    window.open("../../Inception/MandateListing.cfm?mission=#URL.Mission#&ts="+new Date().getTime(),"right")
	}
	
	function summary(mis,man,mode) {
	   	ptoken.open("../../../Reporting/PostView/Staffing/PostView.cfm?SystemFunctionid=#url.systemfunctionid#&Mission=" + mis + "&Mandate=" + man + "&ID=" + mode, "_top", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=yes");
	}
	
	function actions() {
	 	ptoken.open("../../Authorization/Staffing/TransactionView.cfm?Mission=#URL.Mission#",  "assignmentapproval");
	}
	
	function employee() {
	 	ptoken.open("../../Employee/EmployeeSearch/InitView.cfm?Mission=#URL.Mission#&ID=Search3.cfm", "employeeinquiry");
	}
	
	function orgaccess() {
	 	ptoken.open("#SESSION.root#/System/Organization/Access/OrganizationView.cfm?Mission=#URL.Mission#",  "accessscreen", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=yes");
	}
	
	function doChangeDate() {
	   ColdFusion.Event.callBindHandlers('selectiondate',null,'change');
	}
	
	</script>

</cfoutput>

<!--- prepare query --->

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Post">
<cf_tl id="Please wait" var="1">
<cfset pwait=#lt_text#>

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT Post.*, 
         P.ViewOrder, 
		 P.Description as ParentDescription, 
		 G.PostGradeParent, 
		 G.PostOrder, 
		 Occ.OccupationalGroup, 
		 Occ.Description
  INTO   userQuery.dbo.#SESSION.acc#Post
  FROM   Position Post, 
         Applicant.dbo.Occgroup Occ, 
         Applicant.dbo.FunctionTitle F, 
	     Ref_PostGrade G,
	     Ref_PostGradeParent P,
	     Organization.dbo.Organization Org
  WHERE  Occ.OccupationalGroup = F.OccupationalGroup
  AND    G.PostGrade   = Post.PostGrade
  AND    P.Code        = G.PostGradeParent
  AND    F.FunctionNo  = Post.FunctionNo 
  AND    Org.OrgUnit   = Post.OrgUnitOperational
  <cfif getAdministrator(url.mission) eq "0">
  AND    P.PostType IN (SELECT ClassParameter 
			   	        FROM   Organization.dbo.OrganizationAuthorization 
				        WHERE  UserAccount = '#SESSION.acc#' 
				        AND    Mission     = '#URL.Mission#')
  </cfif>	
  AND    Org.Mission = '#URL.Mission#'	
</cfquery>

<cf_divscroll height="100%">

<table width="100%" height="100%">

<tr><td valign="top" id="treebox">

	<cfform target="right" name="treeview">

	<table width="93%" border="0" align="center">
	
	  <tr><td height="4"></td></tr>  
	 
	  <tr><td valign="top">
	  
	  <cfquery name="Mandate" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT   DISTINCT MandateNo, Description, DateEffective, DateExpiration 
		      FROM     Ref_Mandate
		   	  WHERE    Mission = '#URL.Mission#'
			  AND     Operational = 1
			  ORDER BY DateEffective DESC
		  </cfquery>
	
		<table width="100%" align="center">
					
		 <cfif mandate.recordcount gte "1">  
							
			<tr>
			<td align="left" style="color:8365AB;height:36px;font-size:16px;padding-left:3px;font-weight:normal" class="labelmedium">
						
			<cf_tl id="Staffing Period">:</td>
			<td align="right" style="padding-right:1px">
				
			  <select name="mandate" id="mandate" class="regularxl" size="1" style="background: color: gray;" 
				onChange="reloadTree(this.value)">
				<cfoutput query="Mandate">
				    <option value="#MandateNo#" <cfif mandatedefault eq MandateNo>selected</cfif>>#MandateNo#</option>
				</cfoutput>
			  </select>
					 
			</td>
			</tr>
		
		</cfif>	
				
		<tr><td colspan="2">
		
		 <table width="100%" class="navigation_table formpadding">
			 
		  <cfoutput query="Mandate">
		  
		    <cfif MandateNo eq URL.Mandate>
			  <cfset cl = "gray">
			<cfelse>
			  <cfset cl = "0080C0">
			</cfif>
					
		    <tr bgcolor="<cfif MandateNo eq URL.Mandate>eaeaea</cfif>" class="navigation_row linedotted">
		     <td width="10" style="padding-left:10px;padding-top:3px">
			 <img src="#SESSION.root#/Images/select.png" height="25" alt="" border="0">		 
			 </td>
			
		     <td height="20" style="padding-left:5px" class="labelit">
				 <cfif MandateNo eq URL.Mandate><cfelse><a href="javascript:summary('#URL.Mission#','#MandateNo#','0')"></cfif>#DateFormat(DateEffective,"MMMM-YYYY")#
				 </td>
				 <td style="padding-right:5px;padding-left:5px">-</td>
				 <td class="labelit">				 
				  <cfif MandateNo eq URL.Mandate><cfelse><a href="javascript:summary('#URL.Mission#','#MandateNo#','0')"></cfif>#DateFormat(DateExpiration,"MMMM-YYYY")#				 
			     </td>			 	
			</tr>
			
		  </cfoutput>
		  
		  </table>
		  </td>
		 </tr>
				 	
		</table>
		
	 </td></tr>	
	 
	 <cfinvoke component = "Service.Access"  
		   method           = "staffing" 
		   mission          = "#URL.Mission#"
		   mandate          = "#URL.Mandate#"
		   returnvariable   = "mandateAccessStaffing">	
		   
		<cfinvoke component = "Service.Access"  
		   method           = "position" 
		   mission          = "#URL.Mission#"
		   mandate          = "#URL.Mandate#"
		   returnvariable   = "mandateAccessPosition">	   
		   
			
	<cfif mandateAccessStaffing eq "NONE" and mandateAccessPosition eq "NONE">
	
	 <tr><td align="center" class="labellarge">
		<font color="FF0000">No access granted to this period</font>
	 </td></tr>
	 <!--- selection date --->
	  
	<cfelse> 
	
 	<tr class="line labelmedium"><td style="color:8365AB;font-size:16px;height:32;"><cf_tl id="Functions"></td></tr>								
		
	 
	 <tr><td>
	
		 <table width="100%">
		  
		  <tr><td style="padding-left:0px">
		
				<table width="100%" align="left">
				
					<tr><td>					
					<cfset heading   = "">
					<cfset module    = "'Staffing'">
					<cfset selection = "'Period'">
					<cfset menuclass = "'Period'">
					<cfset except    = "'Position Management'">
					<cfset color     = "ffffcf">					
					<cfinclude template="../../../../Tools/SubmenuLeft.cfm">
					</td></tr> 
				
				</table>
				
			  </td></tr>	
						  
			   <cfquery name="getMandate" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT *
				      FROM   Ref_Mandate
				   	  WHERE  Mission   = '#URL.Mission#'
					  AND    MandateNo = '#url.mandate#'	
					  AND    Operational = 1	
					  ORDER BY MandateDefault DESC 
				</cfquery>				
			 
			 <!--- -------------------------- --->	
			
			 <tr><td style="height:4px"></td></tr>
						
			 <tr><td>
			           
				<cfif getMandate.DateExpiration lt now() >
				       <CF_DateConvert Value="#DateFormat(getMandate.DateExpiration,CLIENT.DateFormatShow)#">					   
				<cfelseif getMandate.DateEffective gt now()>   
				       <CF_DateConvert Value="#DateFormat(getMandate.DateEffective,CLIENT.DateFormatShow)#">					   
				<cfelse> 
				 	   <CF_DateConvert Value="#DateFormat(now(),CLIENT.DateFormatShow)#">
				</cfif>
								
				<cfset sel = dateValue> 
							 
				 <table>
				    <tr class="labelmedium">
					<td colspan="2" style="height:35px;padding-left:4px;padding-right:5px">
					<cf_tl id="Selection date">:</td>
					<td>
							
							<cf_intelliCalendarDate9
								FieldName="selectiondate" 
								Manual="True"		
								class="regularxl"					
								DateValidStart="#Dateformat(getMandate.DateEffective, 'YYYYMMDD')#"
								DateValidEnd="#Dateformat(getMandate.DateExpiration, 'YYYYMMDD')#"
								Default="#Dateformat(sel,client.dateformatshow)#"
								scriptdate= "doChangeDate"
								AllowBlank="False">	
								
					</td>						
					</tr>
				</table>
			 
			    </td>
			</tr>	 
			
			<tr><td height="28" colspan="2" style="padding-top:10px;font-size:16px" class="labelmedium line">
			
			<cfoutput>
			    						
				<a target="right" href="MandateViewOpen.cfm?ID=Locate&ID2=#URL.Mission#&ID3=#MandateDefault#">
				<cf_tl id="Extended search">
				</a>			
				
			</cfoutput>
						
			</td></tr>				
			
			<tr class="line labelmedium"><td style="padding-top:10px;color:8365AB;font-size:16px;height:42;"><cf_tl id="Organizational Structure"></td></tr>								
									  
		    <tr><td colspan="2" align="center">
				<table width="99%" align="right">
				<tr><td>
						
					<cf_tl id="Operational Structure" var="1">							
					<cf_UItree name="idtree" bold="No" format="html" required="No">
				     <cf_UItreeitem
						  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.mission#','#mandatedefault#','#session.root#/Staffing/Application/Position/MandateView/MandateViewOpen.cfm','ORG','#lt_text#','#url.mission#','#mandatedefault#','','','0','',{selectiondate})">
				    </cf_UItree>
					
				</td></tr>
				</table>
			</td></tr> 	
					
			<!--- check if administrative + static --->		
		
			<cfquery name="Admin" 
			datasource="AppsOrganization" 
			maxrows=1 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM  Ref_Mission M
				WHERE Mission = '#url.Mission#'
				AND TreeAdministrative IN (SELECT Mission FROM Ref_Mission WHERE MissionStatus = '1')
				AND TreeAdministrative IN (SELECT Mission FROM Organization WHERE Mission = M.TreeAdministrative)
			</cfquery> 
			
			<cfif Admin.Recordcount eq "1">
							
				<tr><td height="1" colspan="2" class="line"></td></tr>
							
				<tr><td colspan="2" align="center">
					<table width="99%" align="right">
					<tr><td>
						<cf_tl id="Administrative Structure" var="1">	
							
						<cf_UItree name="idtree1" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
					     <cf_UItreeitem
						  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.mission#','#mandatedefault#','../../Staffing/Application/Position/MandateView/MandateViewOpen.cfm','ORA','#lt_text#','#admin.treeadministrative#','P001')">
					    </cf_UItree>
						
					</td></tr>
					</table>
				</td></tr> 		
			
			</cfif>				
		
			<cfquery name="Funct" 
			datasource="AppsOrganization" 
			maxrows=1 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_Mission M
				WHERE  Mission = '#url.Mission#'
				AND    TreeFunctional IN (SELECT Mission FROM Ref_Mission WHERE MissionStatus = '1')
				AND    TreeFunctional IN (SELECT Mission FROM Organization WHERE Mission = M.TreeFunctional)
			</cfquery> 				
						
			<cfif Funct.Recordcount eq "1">
									
				<tr><td height="1" colspan="2" class="line"></td></tr>
						
				<tr><td colspan="2" align="center">
					<table width="99%" align="right">
					<tr><td>
								
						<cf_UITree name="idtree2" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
						
					     <cf_UITreeitem
						  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.mission#','#mandatedefault#','../../Staffing/Application/Position/MandateView/MandateViewOpen.cfm','ORF','Functional Structure','#funct.treefunctional#','P001')">
						  
					    </cf_UITree>
						
					</td></tr>
					</table>
				</td></tr> 		
			
			</cfif>
						
			<tr class="line"><td style="color:8365AB;font-size:16px;height:32;" ><cf_tl id="Views and Quick listings"></td></tr>				
						
						
			<tr><td colspan="2" align="center" style="padding-top:4px">
			
				<table width="99%" align="right">
					<tr><td id="mandatetree">
					
					<cf_MandateTreeData
						  mission="#URL.Mission#"	  
						  mandatedefault="#mandatedefault#">	  	
						
					</td></tr>
				</table>
			
			</td></tr>
							
			</table>
		
		</td></tr>
		
		</cfif>
	
	</table>

	</td></tr>

</table>

</cfform>

</td></tr>

</table>

</cf_divscroll>

<cfset ajaxonload("doCalendar")>
<cfset ajaxonload("doHighlight")>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Post"> 
	