<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name="AddCities" 
datasource="appsTravelClaim" >
INSERT INTO  Ref_CountryCity
             (CountryCityId, LocationCountry, LocationStateCode, LocationState, LocationCity, LocationCityCode, OfficerUserId)
SELECT       I.ser_num, I.f_cnty_id_code, I.f_admt_id_code, I.State, I.name, I.search_term, 'nucleus' AS Expr1
FROM         IMP_CITY I LEFT OUTER JOIN
             Ref_CountryCity City ON I.ser_num = City.CountryCityId
GROUP BY     I.f_cnty_id_code, I.name, I.ser_num, I.f_admt_id_code, I.State,I.search_term, City.CountryCityId
HAVING       City.CountryCityId IS NULL
</cfquery>

<cfquery name="UpdateCities" 
datasource="appsTravelClaim" >
UPDATE    Ref_CountryCity
SET       LocationCity      = IMP_CITY.name, 
          LocationCityCode  = IMP_CITY.search_term,
		  LocationCountry   = IMP_City.f_cnty_id_code,
		  LocationStateCode = IMP_City.f_admt_id_code,
		  LocationState     = IMP_City.State
FROM      IMP_CITY INNER JOIN
          Ref_CountryCity ON IMP_CITY.ser_num = Ref_CountryCity.CountryCityId
</cfquery>

