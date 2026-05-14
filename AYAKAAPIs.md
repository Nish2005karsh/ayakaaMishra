AYAKA APIs
1) Driver Login
POST: ht Loqin
PARAMS: mobile:8884200798
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "Valid Mobile Number"
  },
  "user_id": 31
}
Error Response:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Invalid Mobile Number"
  },
  "user_id": 0
}
2) Verify OTP
Endpoint: i/verify_otp
PARAMS: user_id:31, otp:123456
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "Login Successful"
  },
  "user_id": 153,
  "access_token": "ya29.c.c0ASRK0GbO59cGoA5mQrhFeb36vZvgewvbMZVPHLMW3_mSd2xDL2fk1o2laLjkQQpPkbCT0ZiQmdAWLv4hgJWO4LzrOOgjvmOPVWzXeF6HtD8EDGOxskDKxOo9TuzAbJdzBS-XK3e-1HfAGSq0dqgNTZbo9pxbWoBxH0-tn0cm75yFlUfd5LeeP-RtmB07MygRtRUNSufv_DsRBp4Aj-OM8wzXDH9NK0EOoMzVm0PZxbq5obtcHBjquJbyq-4rLtNUyqSjtBix_IfxR31W-rWvGByKI9--qJrCa_imfKz_-qdbvUAXTZ5rXWxVTlFwgu9DAgBDZrhs358FWG3MTufmOzU70QKuAMz-3lHASkQ1cRUS_k3pQhVKGtqrE385AXpXIbwwtbk7JV01wISup8wcBfd3sm1vXXh09x6mSln6XS4BMUcloe2bttXMqRqnta41zvY4jS74oOZi6mBO6M7239uddptbqSk-fMVdumM4zdyF1is5e1_zkR1X-23t5WFsgJ6VXYmqq4g-lUhisj_smvt5w5nsug-IZ-s3ms5yl09r3xYiVjruIpXh6vFkF2XxXu9J6zUF3nVMrygpc6JUVgModa9gOcMg3sJYJJZwWgaUoaBXpB0ozFrQ8rkW53F09l83UqnOi8JO19bgVxXvkQWsMOBvMVagkYf3c7i9d49txcyz5wqylIW70zt04RZaB2Z06Mw3JIeQz5nFyspYRfQZRQo2Q9dyRa-BrBVJI539wvk09Qd-8eumpIRjWqZn2wdSbetS82OXMMjQvyOb6JoWYWpSOU37fldsS1OU623oBiOrIch6gBW7X88OukpxlkWfXg_sYv11Xhdqtlix3zWamV6ol0ZVxrRcuoFrvljcxFUdfxw7-9F12tY02ZdRFk0-R6u-p1sbhcr0VmpMtnSfIBQXR4IbWwf4M8W8hn96idZMzOSWdhVtZcf1M4O0rQn8zbVRRQliaRkex4tjZOBmti5QUt4b0U6pe20jyumRl0O8ngf4Um7",
  "driver": {
    "d_id": 1,
    "user_id": 153,
    "driver_name": "cisco driver 1",
    "driver_mail": "ciscodriver1@gmail.com",
    "driver_dob": "2000-03-03",
    "driver_city": "banglore",
    "driver_mobileNo": "2323445544",
    "driver_Alt_mobileNo": "2323543242",
    "driver_id": "ciscodriver1",
    "garage": "1/8,Prestige Technopolis,Dr.MH Maregowda Road,Adugodi,Bengaluru,Karnataka 560029,India",
    "garage_geocode": "12.93363,77.60125",
    "driver_currentAddress": "btm layout banglore",
    "driver_permentAddress": "btm layout banglore",
    "driver_gender": "male",
    "vendor_id": 1,
    "added_by_id": 86,
    "driver_company": 32,
    "imei_number": "343434334331234",
    "sim_number": "233433445645",
    "driver_status": 0,
    "reject_reson": null,
    "driver_approval": 1
  },
  "doc_exp_flag": 0,
  "profile_photo": "Upload/32/driver/153/10/photo/4e0505bb-39c9-4d99-afbc-60ce4067bbbd.jpg"
}
Error Response:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Invalid OTP"
  },
  "user_id": 0,
  "driver": null,
  "driver_docs": null
}
3) Vehicle Registration
POST: ht insert
Note: Keep changing the registerno and driver.
PARAMS:
JSON
Copy
{
  "user_id": 31,
  "company_id": 5,
  "vendor_id": 1,
  "vehicle_id": 2,
  "registerno": "12345",
  "vehicle_status": "0",
  "vehicle_type": 2,
  "contract_id": 1,
  "garage_name": "qwerty",
  "garage_geo_code": "abc",
  "comment": "test",
  "contract_start_date": "2025-05-06",
  "driver": 2
}
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "Vehicle Registered Successfully!"
  }
}
Error Responses:
Company Not Found:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Company Not Found"
  }
}
Vehicle Already Registered:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Vehicle Already registered!!"
  }
}
Driver Already Registered With Another Vehicle:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Driver Already registered With Another vehicle!!"
  }
}
General Failure:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Failed to Register Vehicle!"
  }
}
Update Vehicle State:
plain
Copy
https://royalblue-kudu-237366.hostingersite.com/api/update_vehicleState?company_id=5&vehicle_id=55&vehicle_status=1
4) Driver Documents
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "Documents Found!"
  },
  "data": [
    {
      "document_id": 1,
      "document_name": "Licence",
      "fileds": "{\n  \"fields\":[\n    {\n      \"label\":\"License Number\",\n      \"name\":\"license_number\",\n      \"type\":\"text\",\n      \"required\":true\n    },\n    {\n      \"label\":\"License Expiry Date\",\n      \"name\":\"expire_date\",\n      \"type\":\"date\",\n      \"required\":false\n    },\n    {\n      \"label\":\"License Document\",\n      \"name\":\"doc_data\",\n      \"type\":\"file\",\n      \"required\":false\n    }\n  ]\n}\n",
      "documnet_status": 1
    },
    {
      "document_id": 2,
      "document_name": "Induction",
      "fileds": "{\n  \"fields\":[\n    {\n      \"label\":\"Induction Date\",\n      \"name\":\"induction_date\",\n      \"type\":\"date\",\n      \"required\":true\n    },\n    {\n      \"label\":\"Induction Document\",\n      \"name\":\"doc_data\",\n      \"type\":\"file\",\n      \"required\":false\n    }\n  ]\n}\n",
      "documnet_status": 1
    },
    {
      "document_id": 3,
      "document_name": "Alternate Govt ID",
      "fileds": "{\n  \"fields\":[\n    {\n      \"label\":\"Police Verification\",\n      \"name\":\"status\",\n      \"type\":\"enum\",\n      \"options\":[\"Pending\",\"Success\",\"In Progress\",\"Failed\"],\n      \"required\":false\n    },\n    {\n      \"label\":\"Police Expiry Date\",\n      \"name\":\"expire_date\",\n      \"type\":\"date\",\n      \"required\":false\n    },\n    {\n      \"label\":\"Police Document\",\n      \"name\":\"doc_data\",\n      \"type\":\"file\",\n      \"required\":false\n    }\n  ]\n}\n",
      "documnet_status": 1
    },
    {
      "document_id": 4,
      "document_name": "Police Verification",
      "fileds": "{\n  \"fields\":[\n    {\n      \"label\":\"Police Verification\",\n      \"name\":\"status\",\n      \"type\":\"enum\",\n      \"options\":[\"Pending\",\"Success\",\"In Progress\",\"Failed\"],\n      \"required\":false\n    },\n    {\n      \"label\":\"Police Expiry Date\",\n      \"name\":\"expire_date\",\n      \"type\":\"date\",\n      \"required\":false\n    },\n    {\n      \"label\":\"Police Document\",\n      \"name\":\"doc_data\",\n      \"type\":\"file\",\n      \"required\":false\n    }\n  ]\n}\n",
      "documnet_status": 1
    },
    {
      "document_id": 7,
      "document_name": "Current Address Proof",
      "fileds": "{\n  \"fields\":[\n    {\n      \"label\":\"Current Address Proof\",\n      \"name\":\"doc_data\",\n      \"type\":\"file\",\n      \"required\":false\n    }\n  ]\n}\n",
      "documnet_status": 1
    },
    {
      "document_id": 11,
      "document_name": "Bgv Certificate",
      "fileds": "{\n  \"fields\":[\n    {\n      \"label\":\"BGV Status\",\n      \"name\":\"status\",\n      \"type\":\"enum\",\n      \"options\":[\"Pending\",\"Success\",\"In Progress\",\"Failed\"],\n      \"required\":false\n    },\n    {\n      \"label\":\"BGV Expiry Date\",\n      \"name\":\"expire_date\",\n      \"type\":\"date\",\n      \"required\":false\n    },\n    {\n      \"label\":\"BGV Document\",\n      \"name\":\"doc_data\",\n      \"type\":\"file\",\n      \"required\":false\n    }\n  ]\n}\n",
      "documnet_status": 1
    },
    {
      "document_id": 12,
      "document_name": "Badge",
      "fileds": "{\n  \"fields\":[\n    {\n      \"label\":\"Badge Number\",\n      \"name\":\"number\",\n      \"type\":\"text\",\n      \"required\":false\n    },\n    {\n      \"label\":\"Badge Date\",\n      \"name\":\"issue_date\",\n      \"type\":\"date\",\n      \"required\":false\n    }\n  ]\n}\n",
      "documnet_status": 1
    }
  ]
}
Error Response:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Documents Not Found!"
  }
}
5) Upload Documents
POST: https://ayakademo.checkyourdemo.co.in/public/api/upload_docs
Format: Take the above dynamic fields and send in this format for each field: fields[name]={value}
fields[doc_data]=(file)
Example:
driver_id:7
company_id:5
document_id:4
fields[license_number]=KA123456
fields[expire_date]=2026-04-09
fields[doc_data]=(file)
PARAMS:
JSON
Copy
{
  "driver_id": 7,
  "company_id": 5,
  "document_id": 1,
  "fields": {
    "doc_no": "123456",
    "expiry_dt": "2025-08-21",
    "doc_data": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAA..."
  }
}
Responses:
Success - Insert:
JSON
Copy
{
  "inserted": {
    "status": {
      "code": "0",
      "message": "Document inserted successfully!"
    }
  }
}
Success - Update:
JSON
Copy
{
  "updated": {
    "status": {
      "code": "0",
      "message": "Document updated successfully!"
    }
  }
}
Error - Invalid File:
JSON
Copy
{
  "invalid_base64": {
    "status": {
      "code": "1",
      "message": "Invalid base64file"
    }
  }
}
Error - Decode Failed:
JSON
Copy
{
  "decode_failed": {
    "status": {
      "code": "1",
      "message": "Base64decode failed"
    }
  }
}
Error - Driver Not Found:
JSON
Copy
{
  "driver_not_found": {
    "status": {
      "code": "1",
      "message": "Driver not found"
    }
  }
}
Error - Company Not Found:
JSON
Copy
{
  "company_not_found": {
    "status": {
      "code": "1",
      "message": "Company not found"
    }
  }
}
Error - Missing Parameters:
JSON
Copy
{
  "missing_parameters": {
    "status": {
      "code": "1",
      "message": "Missing required parameters"
    }
  }
}
Error - General Failure:
JSON
Copy
{
  "failed": {
    "status": {
      "code": "1",
      "message": "Failed to upload document!"
    }
  }
}
6) Vehicle Types
GET: ht t types
PARAMS: company_id:5
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "Vehicle Types Found!"
  },
  "data": [
    {
      "vehicle_type_id": 2,
      "vehicle_type_name": "seedan",
      "total_capacity": 4,
      "fuel_type": "Petrol",
      "vehicle_type_status": 0,
      "company_id": 26,
      "added_by": 36,
      "created_on": "2025-05-2710:02:18",
      "company_approved": 1,
      "vehicle_types_approvedBy": 34
    }
  ]
}
Error Response:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Vehicle Types Not Found!"
  },
  "data": []
}
7) Document Names
GET: ht t names
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "Documents Found!"
  },
  "data": [
    {
      "document_id": 1,
      "document_name": "Licence"
    },
    {
      "document_id": 2,
      "document_name": "Induction"
    },
    {
      "document_id": 3,
      "document_name": "Government"
    },
    {
      "document_id": 4,
      "document_name": "Police Verification"
    },
    {
      "document_id": 5,
      "document_name": "Medical Verification"
    },
    {
      "document_id": 6,
      "document_name": "Eye Test"
    },
    {
      "document_id": 7,
      "document_name": "Current Address Proof"
    },
    {
      "document_id": 8,
      "document_name": "Letter Of Undertaking"
    },
    {
      "document_id": 9,
      "document_name": "Training Verification"
    },
    {
      "document_id": 10,
      "document_name": "Photo"
    }
  ]
}
Error Response:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Documents Not Found!"
  },
  "data": []
}
8) Contract List
GET: htt list
Note: vt_id is vehicle type id, v_id is vendor id.
PARAMS: Company_id:5, Vt_id:1, v_id:3
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "Contracts Found!"
  },
  "data": [
    {
      "contract_name": "Trip Basis",
      "contract_id": 1
    }
  ]
}
Error Response:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Contracts Not Found!"
  }
}
9) Trip List (cards)
GET: 9m htt
Case 1 PARAMS: company_id:5, driver_id:7
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "Trips Found!"
  },
  "data": {
    "upcoming": [],
    "ongoing": [],
    "completed": [],
    "rejected": []
  }
}
Case 2 PARAMS (use this for now): company_id:34, driver_id:2, tripHistory:false
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "Trips Found!"
  },
  "data": {
    "upcoming": [
      {
        "trip_direction": "login",
        "trip_date": "2025-08-09",
        "trip_distance": 14.01,
        "trip_time": "17:55:00",
        "tripID": "10011-infosys",
        "office_location": "12.8699,77.6828",
        "office_name": "infosys",
        "employee_location": "12.8860,77.5993",
        "employee_address": "Bannerghatta Main Road,Arekere,Bengaluru Karnataka 560076",
        "employee_landmark": "Bannerghatta Main Road",
        "pickupDrops": [
          {
            "geolocation": "12.8860,77.5993",
            "location_address": "Bannerghatta Main Road,Arekere,Bengaluru,Karnataka 560076",
            "landmark": "Bannerghatta Main Road",
            "trip_time": "17:55:00",
            "boarding_time": "01:00:00",
            "drop_time": "17:55:00",
            "emp_id": 8,
            "emp_name": "emp_bannerghatta"
          }
        ]
      },
      {
        "trip_direction": "login",
        "trip_date": "2025-08-09",
        "trip_distance": 81.3,
        "trip_time": "20:57:00",
        "tripID": "10010-infosys",
        "office_location": "12.8699,77.6828",
        "office_name": "infosys",
        "employee_location": "12.9121,77.6466",
        "employee_address": "HSR Layout Sector 7,Bengaluru,Karnataka 560102",
        "employee_landmark": "HSR Layout Sector 7,",
        "pickupDrops": [
          {
            "geolocation": "12.8997,77.4827",
            "location_address": "kengeri",
            "landmark": "kengeri",
            "trip_time": "20:57:00",
            "boarding_time": "11:44:00",
            "drop_time": "20:57:00",
            "emp_id": 12,
            "emp_name": "emp5"
          },
          {
            "geolocation": "12.8963,77.6325",
            "location_address": "Hosur Road,Bommanahalli,Bengaluru,Karnataka 560068",
            "landmark": "Hosur Road,",
            "trip_time": "20:57:00",
            "boarding_time": "08:00:00",
            "drop_time": "20:57:00",
            "emp_id": 7,
            "emp_name": "emp_hosur"
          },
          {
            "geolocation": "12.9174,77.6226",
            "location_address": "Silk Board Junction,Bengaluru,Karnataka 560068",
            "landmark": "Silk Board Junction",
            "trip_time": "20:57:00",
            "boarding_time": "17:15:00",
            "drop_time": "20:57:00",
            "emp_id": 10,
            "emp_name": "emp_silkboard"
          },
          {
            "geolocation": "12.9121,77.6466",
            "location_address": "HSR Layout Sector 7,Bengaluru,Karnataka 560102",
            "landmark": "HSR Layout Sector 7,",
            "trip_time": "20:57:00",
            "boarding_time": "01:01:00",
            "drop_time": "20:57:00",
            "emp_id": 9,
            "emp_name": "emp_hsr"
          }
        ]
      }
    ],
    "ongoing": [],
    "completed": [],
    "rejected": []
  }
}
10) Trip Details
GET: https details
PARAMS: company_id:34, trip_id:10
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "Trip Details Found!"
  },
  "data": {
    "trip_details": {
      "trip_id": 10,
      "tripID": "10009-cisco_systems",
      "emp_id": "18",
      "emplyoee_type": "employee",
      "employee_geolocation": "13.06,77.63",
      "destination_geolocation": "12.934885,77.696205",
      "trip_direction": "login",
      "trip_date": "2025-10-25",
      "starting_point": "Nagawara,near Hebbal on the Outer Ring Road.",
      "landmark": "Manyata Tech Park",
      "destination": "Electronics City,International Tech Park Bangalore (ITPB)in Whitefield,and Bagmane Tech Park in CV Raman Nagar",
      "office_index": 0,
      "trip_distance": "20.704",
      "extra_distance": "0.000",
      "boarding_time": "09:20:00",
      "route_order": 0,
      "drop_time": "10:00:00",
      "trip_time": "10:00:00",
      "route_id": "10009-cisco_systems",
      "vehicle_id": null,
      "vendor_id": null,
      "trip_status": 0,
      "created_by": 133,
      "created_on": "2025-10-2508:01:34"
    },
    "trip_expenses": [],
    "trip_sheet": [],
    "trip_sheets": []
  }
}
Error Response:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Trip Details Empty!"
  },
  "data": []
}
11) Document Details
GET: htt etails
PARAMS: company_id:5, driver_id:7
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "Document Details Found!"
  },
  "data": [
    {
      "document_id": 1,
      "doc_data": "{\"doc_no\":\"123456\",\"expiry_dt\":\"2025-08-21\",\"doc_data\":\"Upload/5/driver/7/1/licence/8acca457-675a-4d42-8d31-17f95bd54d47.png\"}",
      "expiry_dt": "2025-08-21",
      "id_expired": "1",
      "allow_upload": "1"
    },
    {
      "document_id": 2,
      "doc_data": "{\"induction_date\":\"2026-02-12\",\"doc_data\":\"Upload/5/driver/31/2/induction/e91d55f9-0a54-48dc-9226-25b837f32836.jpg\"}",
      "expiry_dt": null,
      "id_expired": "false",
      "allow_upload": "false"
    },
    {
      "document_id": 3,
      "doc_data": "{\"status\":\"Pending\",\"expire_date\":\"2026-02-06\",\"doc_data\":\"Upload/5/driver/31/3/alternate_govt_id/aa4b1490-b58c-4c5f-9882-6f62a52eb70c.jpg\"}",
      "expiry_dt": null,
      "id_expired": "false",
      "allow_upload": "false"
    },
    {
      "document_id": 4,
      "doc_data": "{\"status\":null,\"expire_date\":null}",
      "expiry_dt": null,
      "id_expired": "false",
      "allow_upload": "false"
    },
    {
      "document_id": 7,
      "doc_data": "[]",
      "expiry_dt": null,
      "id_expired": "false",
      "allow_upload": "false"
    },
    {
      "document_id": 11,
      "doc_data": "{\"status\":\"Pending\",\"expire_date\":null}",
      "expiry_dt": null,
      "id_expired": "false",
      "allow_upload": "false"
    },
    {
      "document_id": 12,
      "doc_data": "{\"number\":null,\"issue_date\":null}",
      "expiry_dt": null,
      "id_expired": "false",
      "allow_upload": "false"
    }
  ]
}
Error Response:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Document Not Found!"
  },
  "data": []
}
12) Driver Availability
GET: ilclest
Vehicle_status: 1 for offline, 0 for online
PARAMS: company_id:5, vehicle_id:55, Vehicle_status:1 for offline
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "Vehicle status updated successfully!"
  }
}
Error Response:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "Vehicle State not updated!"
  }
}
13) Employee Trip OTP Verify
PARAMS: company_id:34, trip_id:1, emp_id:11, otp:828102
Success Response:
JSON
Copy
{
  "status": {
    "code": "0",
    "message": "OTP Matching!"
  }
}
Error Response:
JSON
Copy
{
  "status": {
    "code": "1",
    "message": "OTP Not Matching!"
  }
}




