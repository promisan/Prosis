<cfparam name="URL.EntityGroup" default="">
<cfparam name="URL.Mission"     default="">
<cfparam name="URL.Owner"       default="">
<cfparam name="URL.me"          default="false">
<cfparam name="URL.Sorting"     default="overdue">
<cfparam name="url.mode"        default="myclearance">

<cfset FileNo = round(Rand()*100)>
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Action2_#fileNo#">	

<cfif url.me eq "true">
    <cf_myClearancesPrepare mode="variable" entity="#URL.entitycode#" role="0">
<cfelse>
    <cf_myClearancesPrepare mode="variable" entity="#url.entityCode#" role="1">
</cfif>

<!--- ------------------------------------------- --->
<!--- pending activities with last date of action --->
<!--- ------------------------------------------- --->

<cfquery name="Due" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 
	 SELECT     OA.ActionId, 
	 
	            <!--- last action taken --->
	 
	             (SELECT   TOP 1 OfficerDate 
				  FROM     OrganizationObjectAction
				  WHERE    ObjectId = OA.ObjectId
				  AND      ActionStatus IN ('2','2Y','2N') 
				  ORDER BY OfficerDate DESC) AS DateLast
				  
	 INTO       userQuery.dbo.#SESSION.acc#Action2_#FileNo#
	 
	 FROM       OrganizationObjectAction OA INNER JOIN OrganizationObject O ON OA.ObjectId = O.ObjectId

	 WHERE      OA.ActionStatus = '0'	 		
	 			
				<!--- we take the result from the initial opening as the basis showing
				      same actions or less based on processing --->
					  
				<!--- 16/8 I don't think it is needed hanno	  
	            OA.ActionId IN (#preservesingleQuotes(session.myclear)#) OR 
				--->
				
	<cfif actions neq "">
		<!--- incrementally added --->				
		AND OA.ActionId IN (#preservesinglequotes(actions)#)
	</cfif>
		    
	<cfif URL.EntityGroup neq "">
	 	AND O.EntityGroup = '#URL.EntityGroup#'
	</cfif>
	<cfif URL.Mission neq "">
		AND O.Mission = '#URL.Mission#'
	</cfif>
	<cfif URL.Owner neq "">
	 	AND O.Owner = '#URL.Owner#'
	</cfif>

</cfquery>	


<!--- show detailed actions of this entity --->

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Action">	

<cfset due = dateAdd("d","30",now())>

<cfquery name="Search" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 
 	SELECT  E.EntityCode, 
            E.EntityDescription,
			O.ObjectReference, 
			O.ObjectReference2, 
			O.ObjectURL, 
			O.EntityGroup, 
			O.PersonNo,
			O.Mission as MissionOwner,
			Org.OrgUnit, 
			Org.OrgUnitName, 
			Org.Mission, 
            OA.ActionId, 
			OA.ObjectId, 
			OA.OfficerDate, 
			OA.OfficerFirstName, 
			OA.OfficerLastName, 
			O.OfficerUserId as InceptionOfficer,
			O.OfficerLastName as InceptionLastName,
			O.OfficerFirstName as InceptionFirstName,
			O.Created as InceptionDate,
			O.ObjectDue,
			D.DateLast, 
			P.ActionDescription, 
			P.ActionReference, 
            OA.ActionStatus, 
			OA.ActionFlowOrder, 
			OA.ActionCode, 
			P.ActionLeadTime, 
			
			(SELECT count(*) 
			 FROM   OrganizationObjectActionAccess
			 WHERE  ObjectId   = O.ObjectId
			 AND    ActionCode = OA.ActionCode) as FlyAccess,
			 
			(SELECT count(*) 
			 FROM   OrganizationObjectMail
			 WHERE  ObjectId   = O.ObjectId
			 AND    ActionCode = OA.ActionCode) as MailAccess, 
			 
			(CASE WHEN OA.ActionTakeAction = 0 THEN P.ActionTakeAction ELSE OA.ActionTakeAction END) as ActionTakeAction, 
			
			(CASE WHEN O.ObjectDue is not NULL 
			      THEN CONVERT(int,getDate()-ObjectDue)
				  ELSE CONVERT(int,getDate()-DateLast)
			 END) as Due
			
	FROM    OrganizationObjectAction OA INNER JOIN
            OrganizationObject O ON OA.ObjectId = O.ObjectId INNER JOIN
            userQuery.dbo.#SESSION.acc#Action2_#fileno# D ON OA.ActionId = D.ActionId INNER JOIN
            Ref_Entity E ON O.EntityCode = E.EntityCode LEFT OUTER JOIN
            Organization Org ON OA.OrgUnit = Org.OrgUnit INNER JOIN
            Ref_EntityActionPublish P ON OA.ActionCode = P.ActionCode 
					  AND OA.ActionPublishNo = P.ActionPublishNo 					  
					  
	WHERE   P.EnableMyClearances = 1		
	AND     O.Operational    = 1	
	AND     O.ObjectStatus   = 0
	AND     E.ProcessMode   != '9'	
	 <!--- hide concurrent action that was completed --->
	AND     OA.ActionStatus != '2'		
	AND     E.EntityCode = '#URL.EntityCode#' 
	
    <cfif url.scope eq "portal">
		  AND       E.EnablePortal = 1 
    </cfif>
	<cfif url.EntityDue eq "Due">
		  AND       (O.ObjectDue is NULL or O.ObjectDue <= #due#)
	</cfif>
	
	<cfif url.sorting eq "overdue">
	ORDER BY Due DESC, O.Created 
	<cfelseif url.sorting eq "submitted">
	ORDER BY O.Created
	<cfelseif url.sorting eq "step">
	ORDER BY OA.ActionCode
	<cfelseif url.sorting eq "owner">
	ORDER BY O.Mission
	<cfelse>
	ORDER BY DateLast
	</cfif>	
	 
</cfquery>

<!--- header --->

<cf_mobileRow class="hidden-xs hidden-sm" style="border-bottom:1px solid ##E1E1E1; padding-top:5px; margin-bottom:5px;">

    <cf_mobilecell class="col-xs-1" style="width:40px; text-align:center;" />
    
    <cf_mobilecell class="col-xs-11">
	
        <cf_mobileRow>
            <cf_mobilecell class="col-md-1 col-sm-12" style="width:40px;" />

            <cf_mobilecell class="col-md-8 col-sm-12" style="color:##808080;">
                <cf_tl id="Document Reference">
            </cf_mobileCell>

            <cf_mobilecell class="col-md-1 col-sm-12 text-center" style="color:##808080;">
                <cf_tl id="Action Overdue (hr)">
            </cf_mobileCell>

            <cf_mobilecell class="col-md-1 col-sm-12 text-center" style="color:##808080;">
                <cf_tl id="Workflow Overdue (day)">
            </cf_mobileCell>

            <cf_mobilecell class="col-md-1 col-sm-12 text-center" style="color:##808080;">
                <cf_tl id="Document Overdue (day)">
            </cf_mobileCell>
			
        </cf_mobileRow>
    
	</cf_mobileCell>
	
</cf_mobileRow>

<!--- lines --->


<cfoutput query="Search">	
	
	<cfif ObjectDue neq "">	
	    <!--- leadtime --->									
	    <cfset y = DateDiff("d", "#ObjectDue#", "#now()#")>			
	</cfif>
	
	<cfif DateLast neq "">    
	    <!--- leadtime --->			
	    <cfset x = DateDiff("d", "#DateLast#", "#now()#")>
	    <!--- action time --->
	    <cfset at = DateDiff("h", DateLast, now())>	
	</cfif>
	
	<cfset vWarningColor = "##F15E5E">

    <cf_mobileRow class="rowHighlight clsEntityDetail" style="border-bottom:1px solid ##E1E1E1;">
	
        <cf_mobilecell class="col-xs-1" style="width:40px; text-align:center;">
            <span style="color:##808080; font-size:140%;">#currentrow#.</span>
        </cf_mobilecell>

        <cf_mobilecell class="col-xs-11">
		
            <cf_mobileRow style="cursor:pointer;">
			
                <cf_mobilecell class="col-md-1 col-sm-12" style="width:40px; padding-top:5px;">
				    
                            <cfif ActionStatus eq "2">        
							
                                <cf_tl id="Document action has been completed" var="1">
                                <i class="fas fa-check-square" title="#lt_text#" style="font-size:150%;"></i>
								
                            <cfelse>
                            
                                <cfif DateLast neq "">
                                    
                                    <cfif x gt ActionLeadTime+5>

                                        <cf_tl id="Process this action" var="1">
                                        <i class="fas fa-exclamation-triangle" onclick="process('#ObjectId#')" title="#lt_text#" style="font-size:150%; color:#vWarningColor#;"></i>
                                        
                                    <cfelseif at gt ActionTakeAction and ActionTakeAction gt "0">

                                        <cf_tl id="Action overdue" var="1">
                                        <i class="fas fa-exclamation-triangle" onclick="process('#ObjectId#')" title="#lt_text#" style="font-size:150%; color:#vWarningColor#;"></i>
                                                        
                                    <cfelse>  
															
                                        <cf_img mode="open" onclick="process('#ObjectId#')">	
										
                                    </cfif>
                                    
                                <cfelse>
														
                                    <cf_img mode="open" onclick="process('#ObjectId#')">	
									
                                </cfif>
                                
                            </cfif>					

                </cf_mobilecell>

                <cf_mobilecell class="col-md-8 col-sm-12">
                    
					<div style="font-size:17px">
					    <cfif url.scope neq "portal">
	                        <cfif PersonNo neq "">
	                            <cf_tl id="Click to view person details" var="1">
	                            <span style="color:##0080C0;" onclick="localShowPerson(event,'#PersonNo#')" title="#lt_text#">
	                        </cfif>							
						</cfif>
                        <cfif ObjectReference neq "">#ObjectReference#:</cfif>
                        #ObjectReference2#
                        <cfif PersonNo neq "">
                            </span>
                        </cfif>
                    </div>
					
                    <div style="font-size:14px">
                        <span style="color:##808080;">
                        <cfif Mission neq "">
                            #Mission# : #OrgUnitName#
                        <cfelse>
                            <!--- not on the mission level --->
                        </cfif>
                        <cfif Mission neq "">/</cfif>				
						
                        <span style="color:##DF8E3E;">#ActionDescription#</span>
                        
                        <cfif FlyAccess gte "1" or MailAccess gte "1">
                        
                            <cfquery name="Actor" 
                                datasource="AppsOrganization"
                                username="#SESSION.login#" 
                                password="#SESSION.dbpw#">
                                SELECT   OAS.UserAccount, U.LastName, U.FirstName
                                FROM     OrganizationObjectActionAccess OAS INNER JOIN System.dbo.UserNames U ON OAS.UserAccount = U.Account
                                WHERE    ObjectId   = '#ObjectId#' 
                                AND      ActionCode = '#ActionCode#'
                                UNION
                                SELECT   OAS.Account, U.LastName, U.FirstName
                                FROM     OrganizationObjectMail OAS INNER JOIN System.dbo.UserNames U ON OAS.Account = U.Account
                                WHERE    ObjectId   = '#ObjectId#' 
                                AND      ActionCode = '#ActionCode#'						 
                            </cfquery> 
                            
                            :&nbsp;<cfloop query="Actor">#LastName#<cfif currentrow neq recordcount>,&nbsp;</cfif></cfloop>
                                            
                        </cfif>
                    </div>
                  	
                      <div style="color:##808080;font-size:13px">
					  
					  	<table><tr>
						<cfif getAdministrator("#Mission#") eq "1">			
							<td style="padding-right:4px" id="process_#objectid#">		
							<cf_tl id="Disable" var="1">	
						    <input type="button" name="Disable" value="#lt_text#" class="button10g" 
							  onclick="_cf_loadingtexthtml='';ptoken.navigate('setObjectOperational.cfm?objectid=#objectid#','process_#objectid#')" style="height:20px;width:86px">
							</td>
						</cfif>
						
						<td>
						
						<cf_UIToolTip
                        id         = "d#replace(left(objectid,8),"-","")#"
                        contentURL = "#SESSION.root#/system/entityaction/entityview/myclearancetooltip.cfm?objectid=#objectid#"
                        CallOut    = "true"
                        Position   = "right"
						ShowOn     = "click"
                        Width      = "200"
                        Height     = "100"
                        Duration   = "300">
						<cf_tl id="Requested by">: #InceptionFirstName# #InceptionLastName# (#dateformat(InceptionDate,CLIENT.DateFormatShow)#)
                        <cfif missionowner neq "">[#MissionOwner#]</cfif>						
						</cf_UIToolTip>
						
						</td>
						
						</tr></table>
						
						 </div>
										
                </cf_mobileCell>

                <cf_mobilecell class="col-md-1 col-sm-12 hidden-xs hidden-sm text-center">
                    <cfif DateLast neq "">							
                        <cfif at gt ActionTakeAction AND ActionTakeAction gt "0">
                            <span style="color:#vWarningColor#;font-size:20px">#numberformat(at-ActionTakeAction, ',')#</span>
                        </cfif>				
                    </cfif>	
                </cf_mobileCell>

                <cf_mobilecell class="col-md-1 col-sm-12 visible-xs visible-sm">
                    <cfif DateLast neq "">							
                        <cfif at gt ActionTakeAction AND ActionTakeAction gt "0">
                            <cf_tl id="Action Overdue (h)">: <span style="color:#vWarningColor#;font-size:16px">#numberformat(at-ActionTakeAction, ',')#</span>
                        </cfif>				
                    </cfif>	
                </cf_mobileCell>

                <cf_mobilecell class="col-md-1 col-sm-12 hidden-xs hidden-sm text-center">
                    <cfif ActionStatus eq "1">
                    <span class=""><cf_tl id="On hold"></span>
                    <cfelse>
                        <cfif DateLast neq "">               
                            <cfset x = DateDiff("d", "#DateLast#", "#now()#")>
                            <cfif x gt ActionLeadTime>
                                <span style="color:#vWarningColor#;;font-size:16px">#numberformat(x-ActionLeadTime, ',')#</span>
                            </cfif>
                        </cfif>
                    </cfif>
                </cf_mobileCell>

                <cf_mobilecell class="col-md-1 col-sm-12 visible-xs visible-sm">
                    <cfif ActionStatus eq "1">
                        <cf_tl id="Workflow Overdue">: <cf_tl id="On hold">
                    <cfelse>
                        <cfif DateLast neq "">               
                            <cfset x = DateDiff("d", "#DateLast#", "#now()#")>
                            <cfif x gt ActionLeadTime>
                                <cf_tl id="Workflow Overdue (day)">: <span style="color:#vWarningColor#;;font-size:16px">#numberformat(x-ActionLeadTime, ',')#</span>
                            </cfif>
                        </cfif>
                    </cfif>
                </cf_mobileCell>

                <cf_mobilecell class="col-md-1 col-sm-12 hidden-xs hidden-sm text-center">
                    <cfif ObjectDue neq "">
									
                        <cfif due gt 0>
							<span style="color:#vWarningColor#;;font-size:16px">
                            #numberformat(due, ',')#
							</span>
						<cfelse>
						   <span style="color:6688aa;font-size:14px">
						    #dateformat(ObjectDue,client.dateformatshow)#	
							</span>
                        </cfif>					
                    </cfif>
                </cf_mobileCell>

                <cf_mobilecell class="col-md-1 col-sm-12 visible-xs visible-sm">
                    <cfif ObjectDue neq "">				
                        <cfif due gt 0>
							<span style="color:#vWarningColor#;;font-size:16px">
                            <cf_tl id="Document Overdue (day)">: #numberformat(due, ',')#
							</span>
                        </cfif>
                    </cfif>
                </cf_mobileCell>

            </cf_mobileRow>
			
        </cf_mobileCell>
		
    </cf_mobileRow>
	
</cfoutput>