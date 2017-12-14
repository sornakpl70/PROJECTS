xquery version "3.0";
import module namespace functx="http://www.functx.com" at '/db/core/library/functx/functx.xq';
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"patientLocator",$conf/config/appServices/service[@name="locator"]/location)

let $counter :=  
    if ($admin) then 
        util:eval("patientLocator:getNextCounterVal('PatientId',$loginId)") 
    else 
        let $date := current-date()
      let $month := functx:month-abbrev-en(xs:date($date))
        let $value := substring($date,3,2)

let $counter-Val := doc('../data/counter.xml')
let $val := <data>{
            for $d in  $counter-Val//month
            let $monthDetail := if($d= $month) then $d/@id/string() else()
            return
                $monthDetail
}</data>

 let $counterId :=  util:eval("patientLocator:getNextCounterVal('PatientId')")
return
    concat("P",$val/text(),$value,$counterId)
      



let $patientLoc    := 
    if ($admin) then 
        util:eval("patientLocator:getDataPath('patientMaster',$loginId)")
    else
        util:eval("patientLocator:getDataPath('patientMaster')")
        
let $post-data := 
$profileData
(:<patientInfo>:)
(:    <patientId/>:)
(:    <title>Mr.</title>:)
(:    <registeredDate>2017-02-17T16:21:28.739+05:30</registeredDate>:)
(:    <petName/>:)
(:    <doctor/>:)
(:    <name>:)
(:        <firstname>patient B</firstname>:)
(:        <middlename/>:)
(:        <lastname/>:)
(:    </name>:)
(:    <nationalId>:)
(:        <id/>:)
(:    </nationalId>:)
(:    <language>:)
(:        <type/>:)
(:    </language>:)
(:    <age approximate="false">25</age>:)
(:    <race/>:)
(:    <ethiniCity/>:)
(:    <familySize/>:)
(:    <migrantSeasonal/>:)
(:    <referal/>:)
(:    <income/>:)
(:    <gender>Male</gender>:)
(:    <contactNo>7777777777</contactNo>:)
(:    <primaryEmail>patient B@ff.in</primaryEmail>:)
(:    <lastVisited/>:)
(:    <appiontmentRef/>:)
(:    <dob>1992-01-01</dob>:)
(:    <bloodGroup>A+</bloodGroup>:)
(:    <maritalStatus>Un Assigned</maritalStatus>:)
(:    <userImage/>:)
(:    <weightage/>:)
(:    <emergency>:)
(:        <emergencyDetail>:)
(:            <name/>:)
(:            <contactNo/>:)
(:            <relationship/>:)
(:            <mobileNo/>:)
(:        </emergencyDetail>:)
(:    </emergency>:)
(:    <address>:)
(:        <addressDetail>:)
(:            <userAddressType/>:)
(:            <street1/>:)
(:            <street2/>:)
(:            <city/>:)
(:            <state/>:)
(:            <countryName/>:)
(:            <postalCode/>:)
(:            <emailId/>:)
(:            <phone/>:)
(:            <validFrom/>:)
(:            <validTo/>:)
(:        </addressDetail>:)
(:    </address>:)
(:    <contact>:)
(:        <contactsDetail>:)
(:            <contactType/>:)
(:            <name/>:)
(:            <emailId/>:)
(:            <displayName/>:)
(:            <phone/>:)
(:            <fax/>:)
(:            <mobile/>:)
(:            <validFrom/>:)
(:            <validTo/>:)
(:        </contactsDetail>:)
(:    </contact>:)
(:    <employer>:)
(:        <employerDetail>:)
(:            <occupation/>:)
(:            <employerName/>:)
(:            <employerAddress/>:)
(:            <displayName/>:)
(:            <city/>:)
(:            <state/>:)
(:            <postelCode/>:)
(:            <country/>:)
(:        </employerDetail>:)
(:    </employer>:)
(:    <insurance>:)
(:        <insuranceType>:)
(:            <insuranseType/>:)
(:            <primaryInsuranceProvider/>:)
(:            <planName/>:)
(:            <subscriberid/>:)
(:            <name/>:)
(:            <effectiveDate/>:)
(:            <dateOfBirth/>:)
(:            <gender/>:)
(:            <policyNo/>:)
(:            <groupNo/>:)
(:        </insuranceType>:)
(:    </insurance>:)
(:</patientInfo>:)

return 
    let $filename := concat('Patient-',$counter,'.xml') 
    let $save := xmldb:store($patientLoc,$filename,$post-data)
    
    let $patientDoc := 
        for $patient in collection($patientLoc)
        where $patient//patientId = $post-data//patientId/text()
        return $patient
    let $update := update value $patientDoc//patientId with $counter
    return 
        <response>
            <id>{$counter}</id>
            <name>{$profileData//name/firstname/text()}</name>
        </response>