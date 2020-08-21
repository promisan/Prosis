<cfcomponent displayname="ProsisReact" hint="Prosis React Datasource">
	<cffunction name="getAll" access="remote" hint="send a websocket message" returnType="void">
		<cfargument name="categoryItem" 		Required=false default="">
		<cfargument name="category" 			Required=false default="">
		<cfargument name="searchText" 			Required=false default="">
		<cfargument name="orderBy" 				Required=false default="">
		<cfargument name="PriceSchedule" 		Required=false default="">
		<cfargument name="mission" 				Required=false default="BAMBINO">
		<cfargument name="currency" 			Required=false default="QTZ">
		<cfargument name="selectTopNDiscount" 	Required=false default="">
		<cfargument name="selectTopN" 			Required=false default="">
		<cfargument name="itemNo" 				Required=false default="">

		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfset vSearchText = trim(searchText)>

		<cfoutput>
			<cfsavecontent  variable="priceQuery">
				SELECT ItemNo, 
					UoM as UoMCode,
					UoMDescription as UoM, 
					PriceSchedule, 
					PriceScheduleDescription, 
					ListingOrder,
					Currency, 
					SalesPrice, 
					FieldDefault, 
					PriceDate, 
					PriorPrice, 
					PriorDate,
					ISNULL((SalesPrice-PriorPrice), 0) as PriceOff,
					FLOOR(ISNULL((100*(PriorPrice - SalesPrice))/PriorPrice, 0)*-1) as PriceOffPercentage
				FROM
				(
					SELECT MP.ItemNo, 
						IU.UoMDescription,
						MP.UoM, 
						PriceSchedule, 
						Currency, 
					(
						SELECT TOP (1) ROUND(LP.SalesPrice, 2) AS Expr1
						FROM ItemUoMPrice AS LP
							INNER JOIN
						(
							SELECT ItemNo, 
								UoM, 
								PriceSchedule, 
								MAX(DateEffective) AS LastDate
							FROM ItemUoMPrice AS P
							WHERE(Mission = MP.Mission)
								AND (Currency = MP.Currency)
								AND (DateEffective <= GETDATE())
							GROUP BY ItemNo, 
									UoM, 
									PriceSchedule
						) AS L ON L.ItemNo = LP.ItemNo
								AND L.UoM = LP.UoM
								AND L.PriceSchedule = LP.PriceSchedule
								AND L.LastDate = LP.DateEffective
								AND LP.ItemNo = MP.ItemNo
								AND LP.UoM = MP.UoM
								AND LP.PriceSchedule = MP.PriceSchedule
								AND LP.Mission = MP.Mission
								AND LP.Currency = MP.Currency
					) AS SalesPrice, 
					(
						SELECT TOP (1) LP.DateEffective AS Expr1
						FROM ItemUoMPrice AS LP
							INNER JOIN
						(
							SELECT ItemNo, 
								UoM, 
								PriceSchedule, 
								MAX(DateEffective) AS LastDate
							FROM ItemUoMPrice AS P
							WHERE(Mission = MP.Mission)
								AND (Currency = MP.Currency)
								AND (DateEffective <= GETDATE())
							GROUP BY ItemNo, 
									UoM, 
									PriceSchedule
						) AS L_1 ON L_1.ItemNo = LP.ItemNo
									AND L_1.UoM = LP.UoM
									AND L_1.PriceSchedule = LP.PriceSchedule
									AND L_1.LastDate = LP.DateEffective
									AND LP.ItemNo = MP.ItemNo
									AND LP.UoM = MP.UoM
									AND LP.PriceSchedule = MP.PriceSchedule
									AND LP.Mission = MP.Mission
									AND LP.Currency = MP.Currency
						ORDER BY DateEffective DESC
					) AS PriceDate, 
					(
						SELECT TOP (1) ROUND(LP.SalesPrice, 2) AS Expr1
						FROM ItemUoMPrice AS LP
							INNER JOIN
						(
							SELECT ItemNo, 
								UoM, 
								PriceSchedule, 
								MAX(DateEffective) AS LastDate
							FROM ItemUoMPrice AS P
							WHERE(Mission = MP.Mission)
								AND (Currency = MP.Currency)
								AND (DateEffective <= GETDATE())
							GROUP BY ItemNo, 
									UoM, 
									PriceSchedule
						) AS L_1 ON L_1.ItemNo = LP.ItemNo
									AND L_1.UoM = LP.UoM
									AND L_1.PriceSchedule = LP.PriceSchedule
									AND L_1.LastDate > LP.DateEffective
									AND LP.ItemNo = MP.ItemNo
									AND LP.UoM = MP.UoM
									AND LP.PriceSchedule = MP.PriceSchedule
									AND LP.Mission = MP.Mission
									AND LP.Currency = MP.Currency
						ORDER BY DateEffective DESC
					) AS PriorPrice, 
					(
						SELECT TOP (1) LP.DateEffective AS Expr1
						FROM ItemUoMPrice AS LP
							INNER JOIN
						(
							SELECT ItemNo, 
								UoM, 
								PriceSchedule, 
								MAX(DateEffective) AS LastDate
							FROM ItemUoMPrice AS P
							WHERE(Mission = MP.Mission)
								AND (Currency = MP.Currency)
								AND (DateEffective <= GETDATE())
							GROUP BY ItemNo, 
									UoM, 
									PriceSchedule
						) AS L_1 ON L_1.ItemNo = LP.ItemNo
									AND L_1.UoM = LP.UoM
									AND L_1.PriceSchedule = LP.PriceSchedule
									AND L_1.LastDate > LP.DateEffective
									AND LP.ItemNo = MP.ItemNo
									AND LP.UoM = MP.UoM
									AND LP.PriceSchedule = MP.PriceSchedule
									AND LP.Mission = MP.Mission
									AND LP.Currency = MP.Currency
						ORDER BY DateEffective DESC
					) AS PriorDate, 
						S.Description AS PriceScheduleDescription, 
						S.FieldDefault,
						S.ListingOrder
					FROM ItemUoMPrice AS MP
						INNER JOIN Ref_PriceSchedule S ON MP.PriceSchedule = S.Code
						INNER JOIN ItemUoM IU ON IU.ItemNo = MP.ItemNo AND IU.UoM = MP.UoM
					WHERE Mission = '#arguments.mission#'
						AND Currency = '#arguments.currency#'
					GROUP BY Mission, 
							Currency, 
							MP.ItemNo, 
							MP.UoM,
							IU.UoMDescription, 
							PriceSchedule, 
							S.Description, 
							S.FieldDefault,
							S.ListingOrder
				) AS B	
			</cfsavecontent>
		</cfoutput>

		<cfif categoryItem eq "">
			<cfquery name="qCategoryItem" datasource="AppsMaterials">
				SELECT TOP 1 CategoryItem
				FROM Ref_CategoryItem CI
				WHERE EXISTS
				(
				SELECT 'X'
				FROM Item I
				INNER JOIN ItemImage II
				ON II.ItemNo = I.ItemNo
				INNER JOIN ItemUoM M
				ON M.ItemNo = I.ItemNo
				INNER JOIN ItemUoMMission MI
				ON MI.ItemNo = I.ItemNo
				WHERE I.CategoryItem = CI.CategoryItem
				--AND II.Created>='2019-09-02'
				AND MI.Mission = '#arguments.Mission#'
				AND II.ImageClass = '001'
			)
			ORDER BY NEWID()
			</cfquery>

			<cfset categoryItem=qCategoryItem.CategoryItem>
		</cfif>

		<cfquery name="qItems" datasource="AppsMaterials">
			<cfif trim(selectTopN) eq "">
				SELECT 	*
			<cfelse>
				SELECT TOP #trim(selectTopN)# *
			</cfif>
			FROM (
			SELECT 	 I.Category,
			I.CategoryItem,
			C.Description as CategoryDescription,
			CI.CategoryItemName,
			I.ItemDescription,
			I.ItemNo,
			I.ItemPrecision,
			I.ItemNoExternal,
			II.ImagePath,
			(
			SELECT ROUND(SUM(TransactionQuantity),5)
			FROM   ItemTransaction
			WHERE  ItemNo         = I.ItemNo
			AND    Mission        = MI.Mission
			) as OnHand


			FROM
			Item I
			INNER JOIN Ref_Category C
				ON I.Category = C.Category
			INNER JOIN Ref_CategoryItem CI
				ON CI.Category = I.Category
				AND CI.CategoryItem = I.CategoryItem
			INNER JOIN ItemImage II
				ON II.ItemNo = I.ItemNo
			INNER JOIN ItemUoMMission MI
				ON MI.ItemNo = I.ItemNo
			WHERE 1 = 1
			AND MI.Mission = '#arguments.Mission#'
			AND II.ImageClass = '001'
			
			<cfif trim(arguments.itemno) neq "">
				AND I.ItemNo = '#arguments.itemno#'
			<cfelse>
				<cfif vSearchText neq "">
				AND 
				(
					<cf_softlike left="I.ItemDescription" 	right="#vSearchText#" language="ESP">
					OR
					<cf_softlike left="CI.CategoryItemName" right="#vSearchText#" language="ESP">
					OR
					<cf_softlike left="C.Description" 		right="#vSearchText#" language="ESP">
					OR
					I.itemNo = '#vSearchText#'
					OR
					I.itemNoExternal like '%#vSearchText#%'
				)
				<cfelseif arguments.category neq "">
					AND I.Category = '#arguments.category#'
				<cfelse>
					<cfif trim(selectTopNDiscount) eq "">
						AND CI.CategoryItem = '#CategoryItem#'
					</cfif>
				</cfif>

				<cfif trim(selectTopNDiscount) neq "">
					AND I.ItemNo IN (
						SELECT TOP #trim(selectTopNDiscount)# Px.ItemNo
						FROM (
							#preserveSingleQuotes(priceQuery)#
						) as Px
						INNER JOIN ItemUoMPrice UPx
							ON UPx.ItemNo = Px.ItemNo
							AND UPx.UoM = Px.UoMCode
							AND UPx.PriceSchedule = <cfif arguments.PriceSchedule eq "">
														(
															SELECT	Code
															FROM	Ref_PriceSchedule
															WHERE	FieldDefault = '1'	 
														)
													<cfelse>
														'#arguments.PriceSchedule#'
													</cfif>
							AND UPx.DateEffective = Px.PriceDate
							AND UPx.Mission = '#arguments.Mission#'
							AND UPX.Currency = '#arguments.currency#'
							AND UPx.Promotion = '1'
						WHERE 	Px.PriceOff < 0
						AND 	Px.PriceSchedule = <cfif arguments.PriceSchedule eq "">
														(
															SELECT	Code
															FROM	Ref_PriceSchedule
															WHERE	FieldDefault = '1'	 
														)
													<cfelse>
														'#arguments.PriceSchedule#'
													</cfif>
						ORDER BY Px.PriceOffPercentage ASC
					)
				</cfif>
			</cfif>

			) as XL

			WHERE  OnHand > 0

			ORDER BY <Cfif OrderBy neq "">
			<cfswitch expression="#OrderBy#">
				<cfcase value="stockASC">
					OnHand DESC
				</cfcase>
				<cfcase value="stockDESC">
					OnHand ASC
				</cfcase>
				<cfcase value="descASC">
					ItemDescription ASC
				</cfcase>
				<cfcase value="descDESC">
					ItemDescription DESC
				</cfcase>
				<cfcase value="catASC">
					CategoryDescription ASC
				</cfcase>
				<cfcase value="catDESC">
					CategoryDescription DESC
				</cfcase>
				<cfcase value="priceASC">
					CategoryDescription ASC
				</cfcase>
				<cfcase value="priceDESC">
					CategoryDescription DESC
				</cfcase>
				<cfcase value="discountASC">
					CategoryDescription ASC
				</cfcase>
				<cfcase value="discountDESC">
					CategoryDescription DESC
				</cfcase>

			</cfswitch>

		<cfelse>
			ItemNo
		</Cfif>
		</cfquery>

		<cfset qCandidates = QueryNew("Category,CategoryItem,CategoryDescription,CategoryItemName,ItemDescription,ItemNo,CurrencyFormat,CurrencyId,ItemDescription, ValuationCode,UoMDescription,ItemNoExternal,OnHand,Picture,itemuom", "Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar")>

		<cfloop query ="qItems">

			<cfset thisFile= "D:\Prosis\CHARLIE\Document\#qItems.ImagePath#">

			<cfset vFile = "">
			<cfif (FileExists(thisFile))>
				<cfset vFile = Replace(qItems.ImagePath,'Warehouse/Pictures/','')>
			</cfif>

			<cfquery name="qItemCheck" dbtype="query">
				SELECT *
				FROM qCandidates
				WHERE ItemNo = '#qItems.ItemNo#'
			</cfquery>

			<cfif vFile neq "" and qItemCheck.recordcount eq 0>

				<cfquery name="qUoM" datasource="AppsMaterials">
					SELECT TOP 1 *
					FROM ItemUoM
					WHERE ItemNo = '#qItems.ItemNo#'
				</cfquery>

				<cfif qUoM.recordcount eq 1>
					<cfset temp = QueryAddRow(qCandidates)>
					<cfset Temp = QuerySetCell(qCandidates, "ItemNo", qItems.ItemNo)>
					<cfset Temp = QuerySetCell(qCandidates, "Category", qItems.Category)>
					<cfset Temp = QuerySetCell(qCandidates, "CategoryItem", qItems.CategoryItem)>
					<cfset Temp = QuerySetCell(qCandidates, "CategoryDescription", qItems.CategoryDescription)>
					<cfset Temp = QuerySetCell(qCandidates, "CategoryItemName", qItems.CategoryItemName)>
					<cfset Temp = QuerySetCell(qCandidates, "ItemDescription", qItems.ItemDescription)>
					<cfset Temp = QuerySetCell(qCandidates, "ItemDescription", qItems.ItemDescription)>
					<cfset Temp = QuerySetCell(qCandidates, "ItemNoExternal", qItems.ItemNoExternal)>
					<cfset Temp = QuerySetCell(qCandidates, "OnHand", qItems.OnHand)>
					<cfset Temp = QuerySetCell(qCandidates, "Picture", vFile)>
					<cfset Temp = QuerySetCell(qCandidates, "itemuom", qUoM.UoM)>
				</cfif>
			</cfif>
		</cfloop>

		<cfset result = QueryToArray(qCandidates)>


		<cfloop array="#result#" item="itm">
			<cfquery name="qPrices" datasource="AppsMaterials">
				SELECT 	*
				FROM (
					#preserveSingleQuotes(priceQuery)#
				) as PriceData
				WHERE 	ItemNo = '#itm.itemNo#'
				ORDER BY ListingOrder DESC
			</cfquery>

<!---
AND S.FieldDefault='1'
--->

			<cfset itm.prices = arrayNew(1)>

			<cfquery name="qOffer"
				datasource="AppsMaterials">
				SELECT 	IVO.OrgUnitVendor,IVO.OfferMinimumQuantity
				FROM 	ItemVendor IV 
						INNER JOIN ItemVendorOffer IVO 
							ON IV.ItemNo = IVO.ItemNo
				WHERE 	IV.ItemNo  = '#itm.itemNo#'
				AND 	IV.Preferred = '1'
				ORDER BY DateEffective DESC
			</cfquery>

			<cfloop query="#qPrices#">
				<cfset itm.prices[CurrentRow]["UoM"]=lcase(qPrices.UoM)>
				<cfset itm.prices[CurrentRow]["PriceSchedule"]=qPrices.PriceSchedule>
				<cfset itm.prices[CurrentRow]["PriceScheduleDescription"]=qPrices.PriceScheduleDescription>
				<cfset itm.prices[CurrentRow]["Currency"]="#Left(qPrices.Currency,1)#.">
				<cfset itm.prices[CurrentRow]["SalesPrice"]=qPrices.SalesPrice>
				<cfset itm.prices[CurrentRow]["FieldDefault"]=qPrices.FieldDefault>
				<cfset itm.prices[CurrentRow]["PriorPrice"]=qPrices.PriorPrice>
				<cfset itm.prices[CurrentRow]["PriceOffPercentage"]=qPrices.PriceOffPercentage>
				<cfset itm.prices[CurrentRow]["PriceOff"]=qPrices.PriceOff>
				<cfset itm.prices[CurrentRow]["OfferMinimumQuantity"]=qOffer.OfferMinimumQuantity>
			</cfloop>

		</cfloop>

		<cfif orderBy eq "priceASC" or orderBy eq "priceDESC" or orderBy eq "discountASC" or orderBy eq "discountDESC">
			<cfif orderBy eq "priceDESC" or orderBy eq "discountASC">
				<cfset vASC =  1>
				<cfset vDESC = -1>
			</cfif>

			<cfif orderBy eq "priceASC" or orderBy eq "discountDESC">
				<cfset vASC =  -1>
				<cfset vDESC = 1>
			</cfif>

			<cfscript>
				arraySort(
						result,
						function (e1, e2){
							p1 = -1;
							cfloop(array=e1.prices, index="idx"){
								if (PriceSchedule == '') {
									if (idx.FieldDefault eq 1) {
										if (orderBy == 'priceASC' || orderBy == 'priceDESC') {
											p1 = idx.SalesPrice;
										}
										if (orderBy == 'discountASC' || orderBy == 'discountDESC') {
											p1 = idx.PriceOffPercentage;
										}
									}
								} else {
									if (idx.PriceSchedule == PriceSchedule) {
										if (orderBy == 'priceASC' || orderBy == 'priceDESC') {
											p1 = idx.SalesPrice;
										}
										if (orderBy == 'discountASC' || orderBy == 'discountDESC') {
											p1 = idx.PriceOffPercentage;
										}
									}
								}
							}

							p2 = -1;
							cfloop(array=e2.prices, index="idx"){
								if (PriceSchedule == '') {
									if (idx.FieldDefault eq 1) {
										if (orderBy == 'priceASC' || orderBy == 'priceDESC') {
											p2 = idx.SalesPrice;
										}
										if (orderBy == 'discountASC' || orderBy == 'discountDESC') {
											p2 = idx.PriceOffPercentage;
										}
									}
								} else {
									if (idx.PriceSchedule == PriceSchedule) {
										if (orderBy == 'priceASC' || orderBy == 'priceDESC') {
											p2 = idx.SalesPrice;
										}
										if (orderBy == 'discountASC' || orderBy == 'discountDESC') {
											p2 = idx.PriceOffPercentage;
										}
									}
								}
							}

							if (p1 lt p2)
								return vDESC;

							if (p1 gt p2)
								return vASC;

							if (p1 eq p2)
								return 0;
						}
						);
			</cfscript>

		</cfif>


		<cfscript>
			threadName = "ws_msg_" & createUUID();

			products = structnew("ordered");
			products.products = result;

			msg = SerializeJSON(products);

			cfthread(action:"run",name:threadName,message:msg) {
				WsPublish("prosis",attributes.message);
			}

			writeOutput(msg);
		</cfscript>
	</cffunction>

  	<cffunction name="getCategories" access="remote" hint="send a websocket message" returnType="void">
		<cfargument name="SearchText" Required=false default="">
		<cfargument name="Category" Required=false default="">
		<cfargument name="OrderBy" Required=false default="">

		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfquery name="qCategories" datasource="AppsMaterials">
			SELECT DISTINCT Category, CategoryDescription, CategoryImage
			FROM (
				SELECT 	 I.Category,
						C.Description as CategoryDescription,
						C.Image as CategoryImage,
						(
							SELECT ROUND(SUM(TransactionQuantity),5)
							FROM   ItemTransaction 
							WHERE  ItemNo         = I.ItemNo
							AND	   TransactionUoM = U.UoM
						) as OnHand 
				FROM      
						Item I
						INNER JOIN Ref_Category C
							ON I.Category = C.Category
						INNER JOIN ItemUoM U
							ON I.ItemNo = U.ItemNo		
						INNER JOIN ItemImage II
							ON II.ItemNo = I.ItemNo
						INNER JOIN ItemUoM M
							ON M.ItemNo = I.ItemNo
				WHERE  II.ImageClass = '001'
			) as XL 
			WHERE  OnHand > 0  
			<cfif trim(Category) neq "">
				AND Category = '#Category#'
			</cfif>
			<cfif trim(SearchText) neq "">
				AND <cf_softlike left="CategoryDescription" right="#trim(SearchText)#" language="ESP">
			</cfif>
			ORDER BY 
				<cfswitch expression="#OrderBy#">
					<cfcase value="asc">
						CategoryDescription ASC
					</cfcase>
					<cfcase value="desc">
						CategoryDescription DESC
					</cfcase>
					<cfdefaultcase>
						CategoryDescription ASC
					</cfdefaultcase>
				</cfswitch>
		</cfquery>
		

		<cfset result = QueryToArray(qCategories)>
		
		<cfloop array="#result#" item="itm">
			<cfquery name="qSubCategories" datasource="AppsMaterials">
				SELECT CategoryItem, CategoryItemName,SUM(OnHand)
				FROM (
						SELECT 	 CI.CategoryItem, 
								CI.CategoryItemName,
								(
									SELECT ROUND(SUM(TransactionQuantity),5)
									FROM   ItemTransaction 
									WHERE  ItemNo         = I.ItemNo
								) as OnHand 
						FROM      
								Item I
								INNER JOIN Ref_Category C
									ON I.Category = C.Category
								INNER JOIN Ref_CategoryItem CI
									ON CI.Category = C.Category
									AND I.CategoryItem = CI.CategoryItem
								INNER JOIN ItemImage II
									ON II.ItemNo = I.ItemNo
								INNER JOIN ItemUoM M
									ON M.ItemNo = I.ItemNo
									
						WHERE 	
							C.Category  = '#itm.Category#'
							AND II.ImageClass = '001'
					
					) as XL 
					
					GROUP BY CategoryItem,CategoryItemName
					HAVING SUM(OnHand) > 0	
					ORDER BY CategoryItemName
			</cfquery>
			
			
			
			<cfset itm.subcategories = arrayNew(1)>
			<cfloop query="#qSubcategories#">
				<cfset itm.subcategories[CurrentRow]["categoryitem"]=qSubcategories.categoryitem>
				<cfset itm.subcategories[CurrentRow]["categoryitemname"]=qSubcategories.categoryitemname>
			</cfloop>	
						
			
		</cfloop>
		

		<cfscript>
			threadName = "ws_msg_" & createUUID();
			
			categories = structnew("ordered");
			categories.categories = result;
			
			msg = SerializeJSON(categories);

			cfthread(action:"run",name:threadName,message:msg){
				WsPublish("prosis",attributes.message);
			}

			writeOutput(msg);
		</cfscript>
  	</cffunction>



 	<cffunction name="QueryToArray" access="private" hint="transpose query object to something more serializable">
		<!--- ray camden first wrote one of these functions, props to him --->
		<cfargument type="query" name="q">
			<cfset result = ArrayNew(1)>
			<cfset cols = q.columnList>
			<cfset colsLen = listLen(cols)>
			<cfloop from="1" to="#q.recordCount#" index="i">
				<cfset struct = {}>
				<cfloop from="1" to="#colsLen#" index="k">
					<cfset struct[lcase(listGetAt(cols, k))] = q[listGetAt(cols, k)][i]>
				</cfloop>
				<cfset tmp = ArrayAppend(result, struct)>
			</cfloop>
		<cfreturn result>
  	</cffunction>

	<cffunction name="mobilePwdReset"
			access="remote"
			hint="send a websocket message"
			returnformat="json"
			returnType="any">

		<cfargument name="email" 	type="string" required="true" default="">
		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfset SESSION.login = "sa">
		<cfset SESSION.dbpw = "621*/4106">
		<cfset client.PersonNo = "000">
		<cfset session.acc = "admin">
		<cfset session.last = "admin">
		<cfset session.first = "admin">
		<cfset session.authent = "1">
		<cfset APPLICATION.DateFormat = "dd/mm/YYYY">
		<Cfset APPLICATION.DateFormatSQL = "YYYY-mm-dd">
		<cfset APPLICATION.BaseCurrency = "QTZ">
		<cfset client.dateformatshow = "dd/mm/YYYY">

		<cfinvoke component="Service.Access.MobileAccess"
			Method            = "PasswordReset"
			Email             = "#trim(arguments.email)#"
			Welcome           = "Charlie Internacional"
			Root              = "https://tienda.charlieinternacional.com/"
			returnvariable     = "functionResult">

		<cfset SESSION.login = "">
		<cfset SESSION.dbpw = "">
		<cfset client.PersonNo = "000">
		<cfset session.acc = "admin">
		<cfset session.last = "admin">
		<cfset session.first = "admin">
		<cfset session.authent = "0">

		<!---
		0 : Error - Email does not exist
		1 : OK
		--->

		<cfset qResponse = QueryNew("Status", "Varchar")>

		<cfset temp = QueryAddRow(qResponse)>
		<cfset Temp = QuerySetCell(qResponse, "Status", "#functionResult#")>

		<cfset result = QueryToArray(qResponse)>


		<cfscript>
			threadName = "ws_msg_" & createUUID();

			credentials = structnew("ordered");
			credentials = result;

			msg = SerializeJSON(credentials);

			cfthread(action:"run",name:threadName,message:msg){
				WsPublish("prosis",attributes.message);
		}

				writeOutput(msg);
		</cfscript>

	</cffunction>

	<cffunction name="mobilePwdChange"
			access="remote"
			hint="send a websocket message"
			returnformat="json"
			returnType="any">

		<cfargument name="user" 	type="string" required="true" default="">
		<cfargument name="OldPwd" 		type="string" required="true" default="">
		<cfargument name="Pwd1" 		type="string" required="true" default="">
		<cfargument name="Pwd2" 		type="string" required="true" default="">
		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfset SESSION.login = "sa">
		<cfset SESSION.dbpw = "621*/4106">
		<cfset client.PersonNo = "000">
		<cfset session.acc = "admin">
		<cfset session.last = "admin">
		<cfset session.first = "admin">
		<cfset session.authent = "1">
		<cfset APPLICATION.DateFormat = "dd/mm/YYYY">
		<Cfset APPLICATION.DateFormatSQL = "YYYY-mm-dd">
		<cfset APPLICATION.BaseCurrency = "QTZ">
		<cfset client.dateformatshow = "dd/mm/YYYY">

		<cfinvoke component="Service.Access.MobileAccess"
				Method            = "PasswordChange"
				Account           = "#user#"
				OldPwd            = "#OldPwd#"
				Pwd1              = "#Pwd1#"
				Pwd2              = "#Pwd2#"
				MinLength         = "8"
				SendMail          = "yes"
				Welcome           = "Charlie Internacional"
				Root              = "https://tienda.charlieinternacional.com/"
				returnvariable     = "functionResult">

		<cfset SESSION.login = "">
		<cfset SESSION.dbpw = "">
		<cfset client.PersonNo = "000">
		<cfset session.acc = "admin">
		<cfset session.last = "admin">
		<cfset session.first = "admin">
		<cfset session.authent = "0">

		<!---
		1 : OK
		2: Error - Account does not exist
		3: Error - Old password does not match
		4: Error - new/confirm not the same
		5: Error - new/old are the same
		--->

		<cfset qResponse = QueryNew("Status", "Varchar")>

		<cfset temp = QueryAddRow(qResponse)>
		<cfset Temp = QuerySetCell(qResponse, "Status", "#functionResult#")>

		<cfset result = QueryToArray(qResponse)>

		<cfscript>
			threadName = "ws_msg_" & createUUID();

			credentials = structnew("ordered");
			credentials = result;

			msg = SerializeJSON(credentials);

			cfthread(action:"run",name:threadName,message:msg){
				WsPublish("prosis",attributes.message);
		}

				writeOutput(msg);
		</cfscript>

	</cffunction>

	<cffunction name="mobileLogin"
				access="remote"
				hint="send a websocket message"
				returnformat="json"
				returnType="any">

		<cfargument name="callback" type="string" required="false">
		<cfargument name="user" 	type="string" required="true" default="">
		<cfargument name="pwd" 		type="string" required="true" default="">
		<cfargument name="deviceId" type="string" required="true" default="">
		<cfheader name="Access-Control-Allow-Origin" value="*">

			<cfinvoke component="Service.Access.MobileAccess"
					Method       		= "Authenticate"
					Account      		= "#user#"
					Pwd			   		= "#pwd#"
					DeviceId			= "#deviceId#"
					returnvariable   	= "functionResult">

			<cfset record = deserializeJSON(functionResult)>


					<cfquery name="qUserMission"
				datasource="AppsSystem">
					SELECT        C.CustomerId, U.Account,U.firstName+' '+U.lastName AS NAME, C.OrgUnit
					FROM            UserNames AS U INNER JOIN
					Applicant.dbo.Applicant AS A ON U.PersonNo = A.PersonNo INNER JOIN
					Materials.dbo.Customer AS C ON A.PersonNo = C.PersonNo
					WHERE        (C.Mission = 'BAMBINO')AND (U.Account = '#record.Data.Account[1]#') AND (C.Operational = 1) AND (U.Disabled = 0) AND (A.CandidateStatus = '1')
				</cfquery>


				<cfif qUserMission.recordcount neq 0>


				</cfif>



			<cfset result = QueryToArray(qUserMission)>

			<cfloop array="#result#" item="itm">

				<cfquery name="qAddress"
						datasource="AppsMaterials">
					SELECT CA.AddressType, A.*
					FROM CustomerAddress CA INNER JOIN System.dbo.Ref_Address A
					ON CA.AddressId = A.AddressId
					WHERE CA.CustomerId = '#qUserMission.CustomerId#'
				</cfquery>

				<cfset itm.address = arrayNew(1)>
				<cfloop query="#qAddress#">
					<cfset itm.address[CurrentRow]["AddressId"]=qAddress.AddressId>
					<cfset itm.address[CurrentRow]["AddressType"]=qAddress.AddressType>
					<cfset itm.address[CurrentRow]["Address"]=qAddress.Address>
					<cfset itm.address[CurrentRow]["Address2"]=qAddress.Address2>
					<cfset itm.address[CurrentRow]["AddressCity"]=qAddress.AddressCity>
					<cfset itm.address[CurrentRow]["Country"]=qAddress.Country>
				</cfloop>

				<cfquery name="qSchedule"
						datasource="AppsMaterials">
					SELECT        TOP (1) PriceSchedule
					FROM            CustomerSchedule AS T
					WHERE        (CustomerId = '#qUserMission.CustomerId#')
					AND (DateEffective IN
						(SELECT        MAX(DateEffective) AS Expr1
							FROM            CustomerSchedule
							WHERE        (CustomerId = T.CustomerId)))
				</cfquery>

				<cfset itm.PriceSchedule = qSchedule.PriceSchedule>

			</cfloop>



			<cfscript>
				threadName = "ws_msg_" & createUUID();

				credentials = structnew("ordered");
				credentials = result;

				msg = SerializeJSON(credentials);

				cfthread(action:"run",name:threadName,message:msg){
					WsPublish("prosis",attributes.message);
			}

			writeOutput(msg);
			</cfscript>


	</cffunction>


	<cffunction name="setAnonymous"
			access="remote"
			hint="send a websocket message"
			returnformat="json"
			returnType="any">

		<cfargument name="deviceId" 	type="string" required="true" default="">
		<cfargument name="warehouse" 	type="string" required="true" default="">
		<cfargument name="mission" 		type="string" required="true" default="">
		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfquery name="qCategoryItem" datasource="AppsMaterials">
			SELECT TOP 1 CategoryItem
			FROM Ref_CategoryItem CI
			WHERE EXISTS
			(
			SELECT 'X'
			FROM Item I
			INNER JOIN ItemImage II
			ON II.ItemNo = I.ItemNo
			INNER JOIN ItemUoM M
			ON M.ItemNo = I.ItemNo
			WHERE I.CategoryItem = CI.CategoryItem
			AND II.Created>='2019-09-01'
			)
			ORDER BY NEWID()
		</cfquery>

		<cfset categoryItem=qCategoryItem.CategoryItem>


		<cfquery name="qScheduleDefault"
				datasource="AppsMaterials">
			SELECT Code as DefaultPriceSchedule, W.Country, W.Address, W.City, W.Telephone, W.Fax, W.Contact, '#categoryItem#' as CategoryItem
			FROM Ref_PriceSchedule S,
					Warehouse W
			WHERE S.FieldDefault='1'
			AND W.Warehouse = '#arguments.warehouse#'
		</cfquery>

		<cfset result = QueryToArray(qScheduleDefault)>

		<cfscript>
			threadName = "ws_msg_" & createUUID();

			credentials = structnew("ordered");
			credentials = result;

			msg = SerializeJSON(credentials);

			cfthread(action:"run",name:threadName,message:msg){
				WsPublish("prosis",attributes.message);
			}

			writeOutput(msg);
		</cfscript>

	</cffunction>


	<cffunction name="getQuotes"
			access="remote"
			hint="send a websocket message"
			returnformat="json"
			returnType="any">

		<cfargument name="customerId" type="string" required="true" default="">
		<cfargument name="warehouse" type="string" required="true" default="">
		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfquery name="qQuotes" datasource="AppsMaterials">
			SELECT 	S.*, 
					'Pendiente' as Tag, 
					U.UoMDescription, 
					I.ItemNoExternal,
					C.Description as CategoryDescription,
					S.TransactionDate
			FROM 	UserTransaction.dbo.Sale#arguments.warehouse# S 
					INNER JOIN ItemUoM U 
						ON U.ItemNo = S.ItemNo 
						AND U.UoM = S.TransactionUoM 
					INNER JOIN Item I 
						ON I.ItemNo = U.ItemNo
					INNER JOIN Ref_Category C
						ON I.Category = C.Category
			WHERE 	S.CustomerId = '#arguments.customerId#'
			AND 	S.BatchId IS NULL
			AND 	S.Source = 'Website'
		</cfquery>

		<cfset result = QueryToArray(qQuotes)>

		<cfscript>
			threadName = "ws_msg_" & createUUID();

			credentials = structnew("ordered");
			credentials = result;

			msg = SerializeJSON(credentials);

			cfthread(action:"run",name:threadName,message:msg){
				WsPublish("prosis",attributes.message);
		}

				writeOutput(msg);
		</cfscript>

	</cffunction>


	<cffunction name="postOrder"
			access="remote"
			returnformat="json"
			returnType="any">

		<cfargument name="cart" type="string" required="true">

		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfset SESSION.login = "sa">
		<cfset SESSION.dbpw = "621*/4106">
		<cfset client.PersonNo = "000">
		<cfset session.acc = "admin">
		<cfset session.last = "admin">
		<cfset session.first = "admin">
		<cfset session.authent = "1">
		<cfset APPLICATION.DateFormat = "dd/mm/YYYY">
		<Cfset APPLICATION.DateFormatSQL = "YYYY-mm-dd">
		<cfset APPLICATION.BaseCurrency = "QTZ">
		<cfset client.dateformatshow = "dd/mm/YYYY">

		<cfinvoke component = "Service.Process.EDI.website.materials.Request"
			method           = "addCart"
			cart             = "#Cart#">

		<cfset arrayCart       = deserializeJSON(Cart)>
		<cfset vStore          = arrayCart['store']>
		<cfset vCustomer       = arrayCart['customer']>

		<cfquery name="getSales" datasource="AppsTransaction">
			SELECT 	COUNT(*) AS Total
			FROM  	Sale#vStore.Warehouse#
			WHERE  	BatchId IS NULL 
			AND 	CustomerId = '#vCustomer.CustomerId#' 
			AND 	Source = 'Website'
		</cfquery>
		<cfset vTotalRecords = 0>
		<cfif getSales.RecordCount eq 1>
			<cfif getSales.Total neq "">
				<cfset vTotalRecords = getSales.Total>
			</cfif>
		</cfif>

		<cfset SESSION.login = "">
		<cfset SESSION.dbpw = "">
		<cfset client.PersonNo = "000">
		<cfset session.acc = "admin">
		<cfset session.last = "admin">
		<cfset session.first = "admin">
		<cfset session.authent = "0">

		<cfset qResponse = QueryNew("Status,Description,PendingRecords", "Varchar,Varchar,Varchar")>

		<cfset temp = QueryAddRow(qResponse)>
		<cfset Temp = QuerySetCell(qResponse, "Status", "OK")>
		<cfset Temp = QuerySetCell(qResponse, "Description", "OK")>
		<cfset Temp = QuerySetCell(qResponse, "PendingRecords", vTotalRecords)>

		<cfset result = QueryToArray(qResponse)>

		<cfscript>
			threadName = "ws_msg_" & createUUID();

			credentials = structnew("ordered");
			credentials.result = result;

			msg = SerializeJSON(credentials);

			cfthread(action:"run",name:threadName,message:msg) {
				WsPublish("prosis",attributes.message);
			}

			writeOutput(msg);
		</cfscript>

	</cffunction>


</cfcomponent>