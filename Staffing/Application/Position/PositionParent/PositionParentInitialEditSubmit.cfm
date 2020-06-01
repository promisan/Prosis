
<!--- check if changes are allowed --->

<cfif ParameterExists(Form.Delete)> 

	<cftransaction>
	
	<cfquery name="Delete" 
         datasource="AppsEmployee" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
    	 DELETE FROM Position
    	 WHERE  PositionParentId = '#Form.PositionParentId#'
	</cfquery>	

	<cfquery name="Delete" 
         datasource="AppsEmployee" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
    	 DELETE FROM PositionParent
    	 WHERE  PositionParentId = '#Form.PositionParentId#'
	</cfquery>			
	
	</cftransaction>	

<cfelse>	
	
	<cfquery name="get" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	   	 SELECT * 
		 FROM  Position
	     WHERE PositionParentId = '#Form.PositionParentId#'
	</cfquery>	
	
	<cfparam name="Form.PostGrade" default="">
		
	<cfif Form.PostGrade eq "">
		<cf_alert message="Problem, not position grade/level was selected." return="back">
		<cfabort>
	</cfif>
			
	<cfquery name="CheckPost" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	   	 SELECT MIN(DateEffective) as Lowest, 
		        MAX(DateExpiration) as Highest, 
				count(*) as counted 
		 FROM  Position
	     WHERE PositionParentId = '#Form.PositionParentId#'
	</cfquery>	
		
	<!--- check if changes are allowed --->
	
	<cfinvoke component="Service.Access"  
	  method="position" 
	  orgunit="#get.OrgUnitOperational#" 
	  posttype="#get.PostType#"
	  returnvariable="accessPosition">
	
	<cfif checkPost.counted gte "2"  and AccessPosition neq "ALL">
		<cf_alert message="Problem, you are not allowed to change a parent position (Position Loan) once you have several positions against the parent." 
		return="back">
		<cfabort>
	</cfif>
	
	<cfquery name="CheckAss" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	    	 SELECT * 
			 FROM   PersonAssignment
	    	 WHERE  PositionNo IN (SELECT PositionNo 
			                         FROM Position 
								    WHERE PositionParentId = '#Form.PositionParentId#')
			 AND    AssignmentStatus IN ('0','1')		
			 AND    Incumbency = 100		  
	</cfquery>	
	
	<cfif checkAss.recordcount gte "2" and AccessPosition neq "ALL">
		<cf_alert message="Problem, you are not allowed to change a parent position at this stage anymore.">
		<cfabort>
	</cfif>
		
	<cfquery name="Parameter" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
	    FROM Parameter
	</cfquery>
	
	<cfquery name="Mandate" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Ref_Mandate
		 WHERE  Mission = '#Form.Mission#'
		 AND    MandateNo = '#Form.MandateNo#'  
	</cfquery>	
	
	<cfset dateValue = "">
	<cfif Form.ApprovalDate neq ''>
	    <CF_DateConvert Value="#Form.ApprovalDate#">
	    <cfset APP = #dateValue#>
	<cfelse>
	    <cfset APP = 'NULL'>
	</cfif>	
	
	<!--- effective period can only be changed if the mandate status = 0 --->
	
	<cfif Mandate.MandateStatus eq "0" or AccessPosition eq "ALL">
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.DateEffective#">
		<cfset STR = dateValue>
	
		<cfif STR lt Mandate.DateEffective>
	    	<CF_DateConvert Value="#DateFormat(Mandate.DateEffective,CLIENT.DateFormatShow)#">
		    <cfset STR = dateValue>
		</cfif>    
		
		<cfset dateValue = "">
		<cfif Form.DateExpiration neq ''>
		    <CF_DateConvert Value="#Form.DateExpiration#">
		    <cfset END = dateValue>
		<cfelse>
		    <cfset END = 'NULL'>
		</cfif>	
		
		<cfif END gt Mandate.DateExpiration>
		    <CF_DateConvert Value="#DateFormat(Mandate.DateExpiration,CLIENT.DateFormatShow)#">
		    <cfset END = dateValue>
		</cfif> 
				
		<cfquery name="Parent" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		  	 SELECT * 
			 FROM   PositionParent
		   	 WHERE  PositionParentId = '#Form.PositionParentId#'
		</cfquery>	
		
		<cfif end lt str>
			<cf_alert message="Problem, start date (#dateformat(str,CLIENT.DateFormatShow)#) lies after the calculated end date (#dateformat(end,CLIENT.DateFormatShow)#)">
			<cfabort>
		</cfif>
			
	</cfif>	
	
	<cfif Mandate.MandateStatus eq "1" and AccessPosition neq "ALL" and 
		     (END neq Parent.DateExpiration or STR neq Parent.DateEffective)>
		
			<cf_alert message="Mandate has been locked. You are not allowed to make a change to the effective period anymore.">
			<cfabort>
		
	</cfif>
		
	<!--- check if the dates conflict with the position --->
	
	<cfif (STR gt checkPost.lowest or END lt checkPost.highest) and checkPost.Counted gt "1">
		
		<cf_alert message="Parent effective period much be equal or greater to the period covered by the underlying positions #dateformat(checkPost.lowest,CLIENT.DateFormatShow)# - #dateformat(checkPost.highest,CLIENT.DateFormatShow)#.">
		<cfabort>
		
	</cfif>
	
	<cfif Mandate.MandateStatus eq "1" and checkAss.recordcount gte "1" and (STR gt checkPost.lowest or END lt checkPost.highest)>
		
			<cf_alert message="Please adjust the position incumbency before to adjust the effective period.">
			<cfabort>
		
	</cfif>	
	
	<cfif Parameter.SourcePostNumber eq "PositionParent">	
	
		<cfif Form.SourcePostNumber neq "">
		
			<cfquery name="CheckSourcePost" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   PositionParent
				 WHERE  SourcePostNumber    = '#Form.SourcePostNumber#'
				 AND    Mission             = '#Form.Mission#'
				 AND    MandateNo           = '#Form.MandateNo#'
				 AND    PositionParentId   != '#Form.PositionParentId#'
			</cfquery>	
			
			<cfif CheckSourcePost.recordcount gte "1">
			  <cf_alert message = "You have registered an external post Number [#Form.SourcePostNumber#] which is already in use. Operation not allowed.">
		      <cfabort>
			</cfif>
		
		</cfif> 
		
	</cfif>		

	<cfquery name="UpdateParentPosition" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	    	 UPDATE PositionParent
		    	 SET OrgUnitOperational    = '#Form.OrgUnit#',
				     PostGrade             = '#Form.PostGrade#',
					 <cfif Form.Classified eq "0">
					 ApprovalPostGrade     = '',
					 <cfelse>
					 ApprovalPostGrade     = '#Form.ApprovalPostGrade#',
					 </cfif>
					 FunctionNo            = '#Form.FunctionNo#',
					 FunctionDescription   = '#Form.FunctionDescription#',
				     OrgUnitAdministrative = '#Form.OrgUnit1#',
		    		 PostType              = '#Form.PostType#',
					 Fund                  = '#Form.Fund#',
					 ApprovalDate          = #APP#,
					 <cfif Mandate.MandateStatus eq "0" or AccessPosition eq "ALL">
						 DateEffective         = #STR#,
						 DateExpiration        = #END#,
					 </cfif>
					 ApprovalReference     = '#Form.ApprovalReference#'
					
	    	 WHERE PositionParentId = '#Form.PositionParentId#'
	    </cfquery>	
		
		<!--- save the position grouping on the parent level --->
		
		<cfquery name="ResetTopic" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM PositionParentGroup
			WHERE PositionParentId = '#Form.PositionParentId#' 
		</cfquery>
		
		<cfquery name="Topic" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM  Ref_PositionParentGroup
		  WHERE Code IN (SELECT GroupCode 
		                 FROM   Ref_PositionParentGroupList)
		  AND   Code IN (SELECT GroupCode 
		                FROM   Ref_PositionParentGroupMission
						WHERE  Mission = '#Form.Mission#')							 
		</cfquery>
		  
		<cfloop query="topic">
					        
		     <cfset ListCode  = Evaluate("Form.ListCode_#Code#")>
						  
			   <cfquery name="Insert" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 INSERT INTO PositionParentGroup
					 (PositionParentId,
					  GroupCode,
					  GroupListCode, 
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
				 VALUES
					 ('#Form.PositionParentId#', '#Code#', '#ListCode#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
				</cfquery>
			   
		</cfloop>
		
	   <cfquery name="UpdatePosition0" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
			 
			 UPDATE Position
	    	 SET    OrgUnitOperational    = '#Form.OrgUnit#',
			        PostGrade             = '#Form.PostGrade#',				   
				    PostAuthorised        = '1', 				  
				    FunctionNo            = '#Form.FunctionNo#',
				    FunctionDescription   = '#Form.FunctionDescription#',					    
			        OrgUnitAdministrative = '#Form.OrgUnit1#',
	    		
				    <cfif Mandate.MandateStatus eq "0" or (checkPost.Counted eq "1" and checkAss.recordcount eq "0")>	
				    DateEffective         = #STR#,
				    DateExpiration        = #END#,
				    </cfif>
				 
				    PostType              = '#Form.PostType#'		
				    <cfif form.sourcePostNumber neq "">
				    ,SourcePostNumber      = '#Form.SourcePostNumber#'
				    </cfif>
	    	 WHERE  PositionParentId = '#Form.PositionParentId#'
			 <!--- added to prevent reset of interloan mission 10/8/2014 --->
			 AND    MissionOperational = Mission			
			 AND    PositionStatus = '0'
			 
		</cfquery>	 
		
		<!--- only the last position will be adjusted here to match the updated parent--->
		
		<cfquery name="CheckLast" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		   	 SELECT   TOP 1 *
			 FROM     Position
	    	 WHERE    PositionParentId = '#Form.PositionParentId#'
			 ORDER BY DateEffective DESC
		</cfquery>	
		
		 <cfquery name="UpdatePosition1" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
						
	    	 UPDATE Position
	    	 SET    OrgUnitOperational    = '#Form.OrgUnit#',
			        PostGrade             = '#Form.PostGrade#',				
			        OrgUnitAdministrative = '#Form.OrgUnit1#',
	    		
				    <cfif Mandate.MandateStatus eq "0" or (checkPost.Counted eq "1" and checkAss.recordcount eq "0")>	
				    DateEffective         = #STR#,
				    DateExpiration        = #END#,
				    </cfif>
				 
				    PostType              = '#Form.PostType#'		
				    <cfif form.sourcePostNumber neq "">
				    ,SourcePostNumber      = '#Form.SourcePostNumber#'
				    </cfif>
				   
	    	 WHERE  PositionParentId = '#Form.PositionParentId#'
			 AND    PositionNo       = '#CheckLast.PositionNo#'
			 <!---  added to prevent reset of interloan mission 10/8/2014 --->
			 AND    MissionOperational = Mission			
			 AND    PositionStatus   = '1'
			 
	    </cfquery>		
		
		<!--- adjust also the assignment record for change in period, orgunit and function during mandate status = 0 --->
		
		<cfquery name="UpdateAssignment" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	    	 UPDATE PersonAssignment
	    	 SET    OrgUnit               = '#Form.OrgUnit#',
			        FunctionNo            = '#Form.FunctionNo#',
				    FunctionDescription   = '#Form.FunctionDescription#'		    
				
	    	 WHERE  PositionNo IN (SELECT PositionNo 
			                       FROM   Position 
								   WHERE  PositionParentId = '#Form.PositionParentId#'
								   AND    PositionStatus = '0')
						  
	    </cfquery>	
		
		<cfif Mandate.MandateStatus eq "0">	
			
			<cfquery name="UpdateAssignmentSTR" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
		    	 UPDATE PersonAssignment
		    	 SET DateEffective = #STR#
					
		    	 WHERE PositionNo IN (SELECT PositionNo 
				                      FROM   Position 
									  WHERE  PositionParentId = '#Form.PositionParentId#')
									  
				 AND DateEffective < #STR#				  
		    </cfquery>	
			
			<cfquery name="UpdateAssignmentEND" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
		    	 UPDATE PersonAssignment
		    	 SET    DateExpiration   = #END#
		    	 WHERE  PositionNo IN (SELECT PositionNo 
				                       FROM   Position 
							 		   WHERE  PositionParentId = '#Form.PositionParentId#')
				 AND    DateEffective > #END#						  
		    </cfquery>	
		
		</cfif>
		
</cfif>		
	
<script>
     	 
	 try {	 	 	 
		 parent.opener.document.getElementById('refresh_positionparent').click()	  
	 } catch(e) {} 
	 parent.window.close();
	  	  
</script>	

