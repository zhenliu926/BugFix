#import <Foundation/Foundation.h>

#define kAppId @"245384368875323"
#define IS_IPHONE (!IS_IPAD)
#define OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#define IS_IPOD ([[UIDevice currentDevice].model isEqualToString:@"iPod"])
#define KEY_STATUS               @"status"
#define KEY_STATUS_OK            @"OK"
#define KEY_RESULTS              @"results"

#define APPLICATION_FONT         @"Myriad Pro"
#define APPLICATION_FONT_BOLD    @"MyriadPro-Bold"

#define HELVETIC_NEUE				@"HelveticaNeue"
#define HELVETIC_NEUE_BOLD		@"HelveticaNeue-Bold"

#define RATIO_SCALEDOWN_VIEW    0.75f
#define RATIO_SCALEUP_VIEW      0.5f

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


#define BORDER_COLOR            0xa8926d
#define TABLE_CELL_COLOR        0x363636

#define ARTICLE_CATEGORY_URL @"articleCategoryUrl"
#define ARTICLE_CATEGORY_NAME @"articleCategoryName"


#define WORK_AND_MONEY_TITLE_COLOR 0x54D88A
#define LOVE_AND_SEX_TITLE_COLOR 0xD55E56
#define MIND_AND_BODY_TITLE_COLOR 0x8AD0C7
#define HOME_AND_FAMILY_TITLE_COLOR 0xE9F7FD

#define THEME_TITLE_COLOR @"articleThemeTitleColor"
#define THEME_TITLE_COLOR_FOR_HTML @"articleThemeTitleColorForHtml"
#define THEME_NAME @"articleThemeName"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//NSString *summary = [[[htmlString stringByStrippingTags] stringByRemovingNewLinesAndWhitespace] stringByDecodingHTMLEntities];
#define WORK_AND_MONEY_ARTICLE_NAME @"WORK AND MONEY"
#define HOME_AND_FAMILY_ARTICLE_NAME @"HOME AND FAMILY"
#define MIND_AND_BODY_ARTICLE_NAME @"MIND AND BODY"
#define LOVE_AND_SEX_ARTICLE_NAME @"LOVE AND SEX"

#define WORK_AND_MONEY_ARTICLE_URL @"http://edit.ivillage.com/export_data/list_nodes?created_after=1254355200&created_before=1341100799&limit=10&skip=0&tid[]=12715&tid[]=13646&tid[]=13573"
#define HOME_AND_FAMILY_ARTICLE_URL @"http://edit.ivillage.com/export_data/list_nodes?created_after=1254355200&created_before=1341100799&limit=10&skip=0&tid[]=12715&tid[]=13646&tid[]=13571"
#define MIND_AND_BODY_ARTICLE_URL @"http://edit.ivillage.com/export_data/list_nodes?created_after=1254355200&created_before=1341100799&limit=10&skip=0&tid%5B%5D=12715&tid%5B%5D=13646&tid%5B%5D=13570"
#define LOVE_AND_SEX_ARTICLE_URL @"http://edit.ivillage.com/export_data/list_nodes?created_after=1254355200&created_before=1341100799&limit=10&skip=0&tid[]=12715&tid[]=13646&tid[]=13572"



#define BLOG_BASE_URL @"http://edit.ivillage.com:80/export_data/node?id="
#define BLOG_TOPBLOG_BASE_URL @"http://api.ivillage.com/export_data/list_nodes?limit=1&tid%5B%5D=12715&tid%5B%5D=13646&tid%5B%5D="


#define WORK_AND_MONEY_BLOG_ARTICLE_URL @"http://edit.ivillage.com:80/export_data/list_nodes?limit=14&tid[]=12715&tid[]=13646&tid[]=13573"
#define HOME_AND_FAMILY_BLOG_ARTICLE_URL @"http://edit.ivillage.com:80/export_data/list_nodes?limit=14&tid[]=12715&tid[]=13646&tid[]=13571"
#define MIND_AND_BODY_BLOG_ARTICLE_URL @"http://edit.ivillage.com:80/export_data/list_nodes?limit=14&tid[]=12715&tid[]=13646&tid[]=13570"
#define LOVE_AND_SEX_BLOG_ARTICLE_URL @"http://edit.ivillage.com:80/export_data/list_nodes?limit=14&tid[]=12715&tid[]=13646&tid[]=13572"
#define NEWEST_BLOG_ARTICLE_URL @"http://edit.ivillage.com/export_data/list_nodes?limit=14&tid[]=12715&tid[]=13646&tid[]=13646"
#define POPULAR_BLOG_ARTICLE_URL @"http://edit.ivillage.com:80/export_data/list_nodes?limit=14&tid[]=12715&tid[]=13646&tid[]=1336"

#define IMAGE_NODE_URL @"http://edit.ivillage.com/export_data/node?id="


#define ARTICLE_TITLE_STYLE @"<p style='word-wrap:margin-left:100px;margin-top:0px;margin-bottom:0px;text-align:left;font-family:Helvetica-Bold;padding-left:12px;font-size:10.5pt;color: %@'>%@</p>"
#define ARTICLE_BODY_STYLE @"<p style='word-wrap:margin-left:0px;margin-top:0px;margin-bottom:0px;text-align:left;font-family:Helvetica;padding-left:12px;font-size:10.5pt;color: black'>%@</p>"


#define IMAGE_STYLE @"<img style=\"border:0px solid #173E8C\"  src=%@ width=\"100\" height=\"90\"align=\"left\"/>"
#define HYPERLINK_STYLE @"<style type='text/css'>a {color:#0079BE text-decoration: none; font-face:MS Sans Serif; font-size:13.3px;}</style>"

#define TITLE_FONT_SIZE @"14.0"
#define TITLE_FONT_STYLE @"Georgia-BoldItalic"
#define BODY_FONT_STYLE @"MS Sans Serif"
#define BODY_FONT_SIZE @"13.3"

#define ENABLE_LOG false
#define TIMEOUT_MILISECS_SERVER  10000
#define TIMEOUT_SECS_SERVER 15
#define TIMER_SECS_LOAD 2
#define LAYOUT_TEXT_SIZE_HEADING_1 20
#define LAYOUT_TEXT_SIZE_HEADING_2 16
#define LAYOUT_TEXT_SIZE_NORMAL 14
#define LAYOUT_TEXT_SIZE_SMALL 10
#define LAYOUT_TEXT_SIZE_BUTTON 12
#define SOUND_BUTTON_CLICK 1
#define SOUND_CLICK 2
#define SOUND_NOTIFY 3
#define  DIALOG_NOBUTTON  0
#define  DIALOG_YESNO  1

/* MESSAGING RELATED STRINGS */
#define MSG_NO_INTERNET_CONNECTIVITY  @"Internet connection lost"
#define ERROR  @"error"
#define MSG_FAILED_CHECKIN_FAR @"Sorry! You are unable to check in, due to your location"
#define MSG_FAILED_CHECKIN_SOON @"Sorry! You are unable to check in, you already checked in today"
#define MSG_SUCCESS_CHECKIN_FIRST @"Congratulations! This is your first time checking in at this location!"
#define MSG_SIGNUP_SUCCESS @"Please check your email account for the activation link"
#define MSG_FAILED @"Please try again later"
#define MSG_REACTIVATE @"Welcome back "
#define MSG_FAILED_SERVER @"An error occured on the server, please try again later"
#define MSG_CALENDAR_PERMISSIONS @"Please enable Calendar permissions for Wutzwhat to use this feature"
#define MSG_TWITTER_RELOGIN @"Please re-login to your twitter account and try again!"
#define MSG_SAME_IMAGE @"You have not changed your profile image"
#define MSG_SUCCESS @"Completed successfully"
#define MSG_SUCCESS_DELETE_USER @"Account deactivated successfully"
#define MSG_CALL_FAILED @"Your device does not support this feature"
#define MSG_SERVER_FAILED @"Unexpected server error, please try again later"
#define MSG_ENTER_FEEDBACK @"Please enter feedback"
#define MSG_ENTER_NAME @"Please enter your name"
#define MSG_INAVLID_CARD_NUMBER @"Invalid card number"
#define MSG_INVALID_CVV_NUMBER @"Invalid CVV number"
#define MSG_INVALID_EXPIRY_DATE @"Invalid expiry date"
#define MSG_PHONE_NUMBER @"Invalid phone number"
#define MSG_FILL_FIELDS @"Please fill in all the required fields."
#define MSG_ADD_TALK_FAILED @"Could not be added.\n Please try again later"
#define MSG_ENTER_ALPHA_NUMERIC @"Please enter alpha-numeric values only"
#define MSG_ENTER_NUMBERS @"Please enter numbers only"
#define MSG_START_DATE_GREATER_THEN_END_DATE @"Starting date cannot be greater than ending date"
#define MSG_SHORT_DESCRIPTION_LIMIT @"Please enter less than 25 alpha-numeric values"
#define MSG_MY_FIND_TITLE_LIMIT @"Please make the title shorter"
#define MSG_SAME_PASSWORD @"Cannot enter the same password again"
#define MSG_ENTER_PASSWORD @"Please enter password"
#define MSG_NETWORK_ERROR @"Network not available at the moment.\n Please try again later"
#define MSG_USERNAME_EXIST @"Username already taken, please select another one"
#define MSG_EMAIL_ALREADY_EXIST @"Email already used, please select another one"
#define MSG_ENTER_ALL_FIELDS @"Please enter all required fields"
#define MSG_ENTER_VALID_COUNTRY @"Please enter a valid country"
#define MSG_PRICE_FILTER @"Invalid Start and End dates."
#define MSG_INVALID_USERNAME @"Invalid username or password"
#define MSG_VALIDATE_EMAIL @"Please validate email"
#define MSG_CREATE_SHIPPING_ADDRESS @"Currently you don't have any shipping address saved. Please create a shipping address first, then try again"
#define MSG_ERROR_WITH_PRICE @"Please select a price"
#define MSG_SELECT_OPTION_FIRST @"Please select an option first"
#define MSG_SELECT_CREDIT_CARD_FIRST @"Please select a credit card first"
#define MSG_LOGOUT @"Are you sure you want to logout?"
#define MSG_ENTER_PROMO_CODE @"Please enter a valid promo code"
#define MSG_SEND_MAIL @"Enter your email address"
#define MSG_PASSWORD_SHORT @"Your password is too short"
#define MSG_ALREADY_SUMBITTED_FIND @"This MyFind is already submitted"
#define MSG_SEARCH_ITEM_NOT_FOUND @"Sorry, we couldn't find your search item"
#define MSG_ADDRESS_INVALID @"Sorry, please enter a valid address"
#define MSG_START_END_DATE_INVALID @"Sorry, please enter valid dates"
#define MSG_SAVED_CONTACT_INFO @"The contact information was successfully saved"
#define MSG_FB_POST_SUCCESS @"Posted to Facebook successfully"

/* TEMP MESSAGES */
#define MSG_FEATURE_UNAVAILABLE @"This function is not available in this version of the app"

/* ERROR CODES*/
#define ERRORCODE_MINUS_THREE  @"-3"
#define ERRORCODE_MINUS_TWO  @"-2"
#define ERRORCODE_MINUS_ONE   @"-1"
#define ERRORCODE_ZERO  @"0"
#define ERRORCODE_TWO  @"2"
#define ERRORCODE_THREE  @"3"
#define ERRORCODE_FOUR  @"4"
#define ERRORCODE_FIVE  @"5"
#define ERRORCODE_SIX  @"6"


/* PROGRAMMING CONSTANTS RELATED STRINGS */
#define  DATE_FORMAT_NOW  @"dd-MM-yyyy HH:mm:ss"
#define  STRING_TRUE  @"true"
#define  STRING_FALSE  @"false"
#define  SEX_MALE  @"Male"
#define  SEX_FEMALE  @"Female"
#define SOUND_ON  1
#define SOUND_OFF  0
#define TIMER_RESPONSE_NAME  @"Response Timer"
#define TIMER_LOAD_NAME  @"Load Timer"
#define INT_YES  1
#define INT_NO  0
#define  DATE_MINUTES  1
#define DATE_HOURS  2
#define DATE_DAYS  3
#define DATE_MONTHS  4
#define LOGGED_BY_CLIENT  @"c"
#define LOGGED_BY_PROVIDER  @"p"
#define FILECHOOSER_FILEPATH  @"filepath"
#define MULTI_SELECT_DATA_IDS  @"multiselect_data_ids"
#define MULTI_SELECT_DATA_NAMES  @"multiselect_data_names"
#define MULTI_SELECT_DATA_ITEMS  @"multiselect_data_items"
#define SINGLE_SELECT_ITEM  @"singleselect_item"
#define INTENT_EXTRAS  @"intent_extras"
#define EXTRAS_SEARCH_CONDTN_TRTMNT  @"search_condtn_trtmnt"
#define EXTRAS_PROVIDER_SERVICES  @"provider_services"
#define TABS_WIDTH_DEFAULT  @0
#define TABS_HEIGHT_DEFAULT  @40


/* SHARED PREFERENCES RELATED STRINGS */
#define SP_SWELLA_DATA  @"swellaData"
#define SP_TOKEN @"app_token"
#define SP_LOGGED_IN_BY @"logged_in_by"
#define SP_USER_ID @"userid"
#define SP_NAME  @"name"
#define SP_EMAIL @"email"
#define SP_PASSWORD  @"password"
#define SP_SOUND_EFFECTS_ONOFF  @"sound_effect"

/* LOOKUP RELATED STRINGS */
#define LOOKUP_TYPE_GENDER @"Gender"
#define LOOKUP_TYPE_LANGUAGE  @"Language"
#define LOOKUP_TYPE_HEALTH_GOAL  @"HealthGoals"
#define LOOKUP_TYPE_HEALTH_CONCERN  @"HealthConcerns"
#define LOOKUP_TYPE_THERAPY_GOAL  @"TherapyGoals"
#define LOOKUP_TYPE_BODY_PART  @"Body Parts"
#define LOOKUP_TYPE_OTHER_INTEREST  @"OtherInterests"
#define LOOKUP_TYPE_REG_PREFERENCE  @"ReligiousPreference"
#define LOOKUP_TYPE_POL_PREFERENCE  @"PoliticalPreference"
#define LOOKUP_TYPE_CREDIT_CARD_TYPE @"CreditCardType"
#define LOOKUP_TYPE_THERAPY_SPECIALTY @"TherapySpeciality"
#define LOOKUP_TYPE_TREATMENT @"Treatment"

#define BODY_PART_HEAD_N_FACE @"Head and Face"
#define BODY_PART_NECK @"Neck"
#define BODY_PART_SHOULDER @"Shoulder"
#define BODY_PART_ELBOW @"Elbow"
#define BODY_PART_WRIST @"Wrist"
#define BODY_PART_BACK @"Back"
#define BODY_PART_HIPS @"Hips"
#define BODY_PART_KNEES @"Knees"
#define BODY_PART_FOOT @"Foot/Ankle"
#define BODY_PARTS @"Body Parts"

#define LOOKUP_NAME_THERAPY_SPECIALTY @"Therapy Speciality"
#define LOOKUP_NAME_HEALTH_GOAL  @"Health Goals"
#define LOOKUP_NAME_HEALTH_CONCERN  @"Health Concerns"
#define LOOKUP_NAME_THERAPY_GOAL  @"Therapy Goals"
#define LOOKUP_NAME_OTHER_INTEREST  @"Other Interests"
#define LOOKUP_NAME_REG_PREFERENCE  @"Religious Preference"
#define LOOKUP_NAME_POL_PREFERENCE  @"Political Preference"
#define LOOKUP_NAME_CREDIT_CARD_TYPE @"Credit Card Type"
#define LOOKUP_NAME_PROFESSIONALISM @"Professionalism"
#define LOOKUP_NAME_AVAILABILITY @"Availability"
#define LOOKUP_NAME_FACILITIES @"Facilities"
#define LOOKUP_NAME_COMMUNICATION @"Communication"
#define LOOKUP_NAME_COMMITMENT @"Commitment"
#define LOOKUP_NAME_TECHNICALSKILLS @"TechnicalSkills"
#define LOOKUP_NAME_RATING @"Rating"

/* JSON RELATED STRINGS */
#define JSON_ERROR_CODE  @"error"
#define JSON_LOOKUP_LOOKUP_ID  @"LookUpId"
#define JSON_LOOKUP_LOOKUP_NAME  @"LookUpName"
#define JSON_BODY_PART_ID  @"BodyPartId"
#define JSON_BODY_PART_NAME  @"BodyPartName"
#define JSON_CONDITIONS_ID  @"HealthConcernId"
#define JSON_CONDITIONS_NAME  @"HealthConcernName"
#define JSON_TREATMENT_ID  @"TreatmentId"
#define JSON_TREATMENT_NAME  @"TreatmentName"
#define JSON_TREATMENT_PRICE  @"Price"

#define JSON_CLIENT @"Client"
#define JSON_CLIENT_PAYMENT  @"Client_Payment"
#define JSON_CLIENT_ADVANCE  @"Client_Advance"
#define JSON_PROVIDER @"Provider"
#define JSON_PROVIDER_PAYMENT  @"Provider_Payment"
#define JSON_PROVIDER_ADVANCE  @"Provider_Advance"

#define JSON_CLIENT_ID @"ClientId"
#define JSON_CLIENT_FNAME  @"FirstName"
#define JSON_CLIENT_LNAME  @"LastName"
#define JSON_CLIENT_NAME  @"UserName"
#define JSON_CLIENT_EMAIL @"Email"
#define JSON_CLIENT_PASSWORD @"Password"
#define JSON_CLIENT_WEB_URL @"WebURL"
#define JSON_CLIENT_GENDER @"Gender"
#define JSON_CLIENT_GENDER_NAME @"GenderName"
#define JSON_CLIENT_AGE @"Age"
#define JSON_CLIENT_HEALTH_GOALS @"HealthGoals"
#define JSON_CLIENT_BODY_PART @"InjuredBodyPart"
#define JSON_CLIENT_HEALTH_CONCERNS @"HealthConcerns"
#define JSON_CLIENT_THERAPY_GOALS @"TherapyGoals"
#define JSON_CLIENT_ACTIVITY_P_WEEK @"ActivityPerWeek"
#define JSON_CLIENT_BUDGET_THERAPY @"BudgetTherapy"
#define JSON_CLIENT_PMT_ADDRESS  @"StreetAddress"
#define JSON_CLIENT_PMT_CITY  @"City"
#define JSON_CLIENT_PMT_PH  @"Phone"
#define JSON_CLIENT_PMT_INSURER  @"HealthInsurer"
#define JSON_CLIENT_PMT_INSURER_PH  @"HealthInsurerPhone"
#define JSON_CLIENT_PMT_INSURER_AC  @"HealthInsurerAccount"
#define JSON_CLIENT_PMT_CC_TYPE  @"CreditCardType"
#define JSON_CLIENT_PMT_CC_NAME  @"CreditCardName"
#define JSON_CLIENT_PMT_CC_NO  @"CreditCardNo"
#define JSON_CLIENT_PMT_CC_CV  @"CV2No"
#define JSON_CLIENT_PMT_FIRSTNAME  @"FirstName"
#define JSON_CLIENT_PMT_LASTNAME  @"LastName"
#define JSON_CLIENT_PMT_COUNTRY  @"CountryCode"
#define JSON_CLIENT_PMT_ZIP  @"ZIPCode"
#define JSON_CLIENT_PMT_STATE  @"State"
#define JSON_CLIENT_PMT_CC_ISSUE  @"IssueDate"
#define JSON_CLIENT_PMT_CC_EXPIRY  @"ExpiryDate"
#define JSON_CLIENT_ADV_HEIGHT_FT  @"HeightFt"
#define JSON_CLIENT_ADV_HEIGHT_IN  @"HeightIn"
#define JSON_CLIENT_ADV_WEIGHT  @"Weight"
#define JSON_CLIENT_ADV_BMI  @"BMI"
#define JSON_CLIENT_ADV_UPLOAD1  @"Upload1"
#define JSON_CLIENT_ADV_UPLOAD2  @"Upload2"
#define JSON_CLIENT_ADV_UPLOAD3  @"Upload3"
#define JSON_CLIENT_ADV_UPLOAD4  @"Upload4"
#define JSON_CLIENT_ADV_UPLOAD5  @"Upload5"
#define JSON_CLIENT_ADV_EXERCISE_P_WEEK  @"ExercisePerWeek"
#define JSON_CLIENT_ADV_OTHER_INTERESTS  @"OtherInterests"
#define JSON_CLIENT_ADV_OTHER_INTERESTS_TXT  @"OtherInterestsText"
#define JSON_CLIENT_ADV_SUMMARY  @"Summary"
#define JSON_CLIENT_ADV_REG_PREF  @"ReligiousPreference"
#define JSON_CLIENT_ADV_POL_PREF  @"PoliticalPreference"

#define JSON_PROVIDER_ID @"ProviderId"
#define JSON_PROVIDER_FNAME  @"FirstName"
#define JSON_PROVIDER_LNAME  @"LastName"
#define JSON_PROVIDER_EMAIL @"Email"
#define JSON_PROVIDER_PASSWORD @"Password"
#define JSON_PROVIDER_WEB_URL @"WebURL"
#define JSON_PROVIDER_CERTIFICATIONS  @"Certifications"
#define JSON_PROVIDER_LANGUAGES @"Languages"
#define JSON_PROVIDER_LOCATION @"Location"
#define JSON_PROVIDER_STREET @"Street"
#define JSON_PROVIDER_STATE @"State"
#define JSON_PROVIDER_CITY @"City"
#define JSON_PROVIDER_ZIP @"Zip"
#define JSON_PROVIDER_GENDER @"Gender"
#define JSON_PROVIDER_THERAPY_SPECIALTY @"TherapySpeciality"
#define JSON_PROVIDER_BODY_PART_SPECIALTY @"BodyPartSpeciality"
#define JSON_PROVIDER_INJURY_SPECIALTY @"InjurySpeciality"
#define JSON_PROVIDER_EXPERIENCE @"Experience"
#define JSON_PROVIDER_ADV_AGE  @"Age"
#define JSON_PROVIDER_ADV_EDUCATION  @"Education"
#define JSON_PROVIDER_ADV_OTHER_INTERESTS  @"OtherInterests"
#define JSON_PROVIDER_ADV_OTHER_INTERESTS_TXT  @"OtherInterestsText"
#define JSON_PROVIDER_ADV_UPLOAD1  @"Upload1"
#define JSON_PROVIDER_ADV_UPLOAD2  @"Upload2"
#define JSON_PROVIDER_ADV_UPLOAD3  @"Upload3"
#define JSON_PROVIDER_ADV_UPLOAD4  @"Upload4"
#define JSON_PROVIDER_ADV_UPLOAD5  @"Upload5"
#define JSON_PROVIDER_ADV_SUMMARY  @"Summary"
#define JSON_PROVIDER_ADV_REG_PREF  @"ReligiousPreference"
#define JSON_PROVIDER_ADV_POL_PREF  @"PoliticalPreference"
#define JSON_PROVIDER_PMT_ADDRESS  @"StreetAddress"
#define JSON_PROVIDER_PMT_CITY  @"City"
#define JSON_PROVIDER_PMT_PH  @"Phone"
#define JSON_PROVIDER_PMT_INSURER  @"HealthInsurer"
#define JSON_PROVIDER_PMT_PAYMENT_RCPT  @"PaymentReceipt"
#define JSON_PROVIDER_PMT_CC_TYPE  @"CreditCardType"
#define JSON_PROVIDER_PMT_CC_NAME  @"CreditCardName"
#define JSON_PROVIDER_PMT_CC_NO  @"CreditCardNo"
#define JSON_PROVIDER_PMT_CC_CV  @"CV2No"
#define JSON_PROVIDER_PMT_CC_ISSUE  @"IssueDate"
#define JSON_PROVIDER_PMT_CC_EXPIRY  @"ExpiryDate"
#define JSON_PROVIDER_PMT_MB_PROGRAM  @"MoneyBackProgram"
#define JSON_PROVIDER_PMT_BA_PROGRAM  @"BidAskProgram"
#define JSON_PROVIDER_TREATMENTS  @"Treatments"

/* WEB METHODS */
#define  WEB_REQUEST  @"request"
#define  WEB_ACTION  @"action"
#define  WEB_DATA  @"data"
#define  WEB_TOKEN  @"token"

#define  WEB_REQUEST_USERS  @"Users"
#define  WEB_REQUEST_PROVIDERS  @"Providers"
#define  WEB_REQUEST_GENERAL  @"General"

#define  WEB_METHOD_SIGN_IN  @"CheckLogin"
#define  WEB_METHOD_USER_FB_SIGN_IN  @"UserFacebookLogin"
#define  WEB_METHOD_SIGN_UP  @"SignUp"
#define  WEB_METHOD_GET_LOOKUP_VALUES @"GetLookup"
#define  WEB_METHOD_GET_BODY_PARTS  @"GetBodyParts"
#define  WEB_METHOD_GET_CONDITIONS  @"GetConditions"
#define  WEB_METHOD_USERS_GET_BASIC_INFO  @"GetUserBasic"
#define  WEB_METHOD_USERS_GET_PAYMENT_INFO  @"GetUserPayment"
#define  WEB_METHOD_USERS_GET_ADVANCE_INFO  @"GetUserAdvanced"
#define  WEB_METHOD_USERS_SAVE_BASIC_INFO  @"EditUser"
#define  WEB_METHOD_USERS_SAVE_PAYMENT_INFO  @"EditUserPayment"
#define  WEB_METHOD_USERS_SAVE_ADVANCE_INFO  @"EditUserAdvanced"
#define  WEB_METHOD_USERS_TESTIMONIALS  @"GetTestimonials"
#define  WEB_METHOD_SEARCH_PROVIDERS  @"SearchProviders"
#define  WEB_METHOD_USERS_GETALLAPPOINTMENTS  @"GetAllClientAppointments"


#define  WEB_METHOD_USERS_APPOINTMENTS  @"GetAppointments"
#define  WEB_METHOD_USERS_GET_APPOINTMENT  @"GetAppointment"
#define  WEB_METHOD_USERS_PROVIDER_TESTIMONIALS  @"GetTestimonialsProvider"
#define  WEB_METHOD_USERS_PROVIDER_APPOINTMENTS  @"GetProviderAppointments"
#define  WEB_METHOD_USERS_GET_PROVIDERS  @"GetProviders"
#define  WEB_METHOD_USERS_GET_PROVIDER_TESTIMONIALS  @"GetProviderTestimonials"
#define  WEB_METHOD_USERS_GET_PROVIDER_PROVIDER_TESTIMONIALS  @"GetProviderProviderTestimonials"
#define  WEB_METHOD_USERS_GET_PROVIDERS_RATING  @"GetProviderRating"
#define	 WEB_METHOD_USERS_SAVE_FEEDBACK		@"SaveFeedback"
#define	 WEB_METHOD_USERS_GET_FEEDBACK		@"GetFeedback"
#define	 WEB_METHOD_USERS_GET_CLIENT_CALENDAR_BY_MONTH		@"GetClientCalendarByMonth"
#define	 WEB_METHOD_USERS_GET_CLIENT_SAVE_CLIENT_REPLY		@"SaveClientReply"


#define  WEB_METHOD_FILE_UPLOAD  @"FileUpload"
#define  WEB_METHOD_GET_FILES @"GetFiles"
#define  WEB_METHOD_REMOVE_FILE @"RemoveFile"
#define  WEB_METHOD_PROVIDER_FB_SIGN_IN				@"ProviderFacebookLogin"
#define  WEB_METHOD_PROVIDERS_GET_BASIC_INFO		@"GetUserBasic"
#define  WEB_METHOD_PROVIDERS_GET_PAYMENT_INFO		@"GetUserPayment"
#define  WEB_METHOD_PROVIDERS_GET_ADVANCE_INFO		@"GetUserAdvanced"
#define  WEB_METHOD_PROVIDERS_SAVE_BASIC_INFO		@"EditUser"
#define  WEB_METHOD_PROVIDERS_SAVE_PAYMENT_INFO		@"EditUserPayment"
#define  WEB_METHOD_PROVIDERS_SAVE_ADVANCE_INFO		@"EditUserAdvanced"
#define  WEB_METHOD_PROVIDERS_GET_PRICE_BOOK		@"GetPriceBookGeneral"
#define  WEB_METHOD_PROVIDERS_SAVE_PRICE_BOOK		@"SavePriceBookGeneral"
#define  WEB_METHOD_PROVIDERS_GET_PRICE_BOOK_SPECIAL		@"GetPriceBookSpecial"
#define  WEB_METHOD_PROVIDERS_SAVE_PRICE_BOOK_SPECIAL		@"SavePriceBookSpecial"
#define  WEB_METHOD_PROVIDERS_GET_APPT_BY_MONTH		@"GetProviderAppointmentsByMonth"
#define  WEB_METHOD_PROVIDERS_SAVE_PROVIDER_SCHEDULE		@"SaveProviderSchedule"
#define  WEB_METHOD_PROVIDERS_GET_DAY_SLOT		@"GetProviderDaySlots"
#define	 WEB_METHOD_PROVIDER_GET_PROVIDER_CALENDAR_BY_MONTH		@"GetProviderCalendarByMonth"
#define  WEB_METHOD_PROVIDERSS_GETALLAPPOINTMENTS  @"GetAllProviderToProviderAppointments"
#define  WEB_METHOD_PROVIDERS_GET_APPOINTMENT		@"GetAppointment"
#define  WEB_METHOD_PROVIDERS_GET_PROVIDER_FEEDBACK @"GetFeedbackProvider"
#define  WEB_METHOD_PROVIDERS_GET_CLIENTS		@"GetClients"
#define  WEB_METHOD_PROVIDERS_SHOW_CLIENTS_QUERIES		@"ShowClientQueries"
#define  WEB_METHOD_PROVIDERS_RESPONSE_CLIENTS_QUERIES		@"ResponseClientQuery"
#define  WEB_METHOD_PROVIDERS_GET_CLIENTS_QUERIES_DETAILS		@"GetClientQueryDetails"
#define  WEB_METHOD_PROVIDERS_SAVE_PROVIDER_FEEDBACK		@"SaveFeedbackProvider"
#define  WEB_METHOD_PROVIDERS_SAVE_CLIENT_QUERY		@"ResponseClientQuery"
#define  WEB_METHOD_PROVIDERS_DENY_CONTRACT		@"DenyContract"


#define  WEB_METHOD_GENERAL_CLIENT_RESPONSE_DETAIL		@"GetProviderClientResponseDetails"
#define  WEB_METHOD_GENERAL_PROVIDER_RESPONSE		@"GetProvidersResponse"
#define  WEB_METHOD_GENERAL_PROVIDER_BOOKED_SLOTS		@"GetProviderDailyBookedSlots"
#define  WEB_METHOD_GENERAL_SAVE_APPOINTMENT		@"SaveAppointment"
#define  WEB_METHOD_GENERAL_GET_APPOINTMENT_DATA		@"GetAppointmentData"
#define  WEB_METHOD_GENERAL_GET_PROVIDER_SERVICE		@"GetProviderSchedule"
#define  WEB_METHOD_FORGET_PASSWORD					@"ForgetPassword"
#define  WEB_METHOD_GENERAL_SAVE_CLIENT_QUERY @"SaveClientQuery"
#define  WEB_METHOD_ASK_DOCTOR					@"AskDoctor"



/* SERVER related messages and errors */
#define SERVER_MESSAGE  @"ServerMessage"
#define SERVER_MSG_SIGNIN_WRONG_EMAIL  @"Incorrect Email/Password."
#define SERVER_MSG_SIGNUP_ALREADY_REGISTERED  @"Email already registered."

#define ACCOUNT_ALREADY_ACTIVATED @"Account Already Activated"

#define SERVER_ERROR_CODE_NO_RECORD  @"No Record Found"
#define SERVER_ERROR_CODE_AUTH_FAIL  @"Authorization Failed"
#define SERVER_ERROR_CODE_UNKNOWN @"Server Error"
#define SERVER_ERROR_CODE_SUCCESS @"Success"
#define SERVER_ERROR_CODE_NO_FILES @"File(s) not found"
#define SERVER_ERROR_CODE_LIMIT_ECXEED @"File Limit exceeded"
#define BASE_URL @"http://api.wutzwhat.com/"
//@"http://174.129.161.33/"
//@"http://api.wutzwhat.com/"
//@"http://192.163.203.149/ww_dev/"
//@"http://api.wutzwhat.com/"
#define BASE_URL_REST11 @"http://184.172.250.60/rest1.1/"
#define LOGIN_URL @"Accounts/Login.svc/login"
#define GET_USER_DATA @"Accounts/Accounts.svc/getUserInfo/access_token="
#define FACEBOOK_LOGIN_URL @"Accounts/Login.svc/facebookLogin"
#define FACEBOOK_CHANGE_NOTIFICATION @"com.wutzwhat.ios:FBSessionStateChangedNotification"
#define REGISTER_URL @"Accounts/Registration.svc/register"
#define FORGOT_PASSWORD_URL @"Accounts/Accounts.svc/forgotpassword/user_email="
#define GET_CITIES_URL @"Settings/Functions/BaseCities.svc/getlist"
#define GET_UNREAD_NOTIFICATIONS @"Accounts/Accounts.svc/unreadNotificationsCount/access_token="
#define SEND_SOCIAL_ACCESS_TOKENS @"Accounts/Accounts.svc/edit_share_settings"
#define ACCESS_TOKEN_URL @"Accounts/Tokens.svc/check_token/access_token="
#define TALK_BASEURL @"http://184.172.250.60/rest1.0/Talks/"
#define ADD_NEW_COMMENT_URL @"AddTalks/AddTalk_restaurant.svc/addrestaurant"
#define EDIT_PROFILE_URL @"Accounts/Accounts.svc/editProfile"
#define LOGOUT_URL @"Accounts/Logout.svc/logout"
#define USERNAME_AVAILABILITY_URL @"Accounts/Registration.svc/check_username/user_name="
#define EMAIL_AVAILABILITY_URL @"Accounts/Registration.svc/check_email/user_email="
#define DELETE_PROFILE @"Accounts/DeleteUser.svc/deleteuser"
#define GOOGLEPLUS_CLIENT_ID @"33460699161.apps.googleusercontent.com"
#define AUTH_TWITTER_POST_REQUEST @"http://api.twitter.com/oauth/request_token"
#define TWITTER_CONSUMERKEY @"uR9Xd8UH0pnuJS6oM46Wxg"
#define TWITTER_CONSUMERSECRET @"G1UCwL8wj36lVvW0fTpn3Ot1f3UtWv3UnV1iETjKUQw"
#define FBCONNECT_API_KEY @"178797275602341"


#define FOOD 1
#define PRODUCTS 2
#define EVENTS 3
#define NIGHTLIFE 4
#define SERVICES 5
#define CONCIERGE 6

#define RESEND_VARIFICATION_EMAIL @"Accounts/Accounts.svc/resendValidationEmail"

#define GET_TALK_LIST @"Feeds/MyFinds/MyFind.svc/getMyFindList"
#define GET_TALK_DETAIL @"Feeds/MyFinds/MyFind.svc/getMyFind"
#define ADD_TALK @"Talks/AddTalks/AddTalk.svc/addTalk/category="
#define LOVE_TALK @"UserResponse/Talks/LoveTalk.svc/loveTalk"
#define UNLOVE_TALK @"UserResponse/Talks/LoveTalk.svc/unloveTalk"
#define FAVORITE_TALK @"UserResponse/Talks/FavoriteTalk.svc/favoriteTalk"
#define UNFAVORITE_TALK @"UserResponse/Talks/FavoriteTalk.svc/unfavoriteTalk"
#define FLAG_TALK @"/UserResponse/Talks/Flag.svc/Flagtalk"
#define UNFLAG_TALK @"UserResponse/Talks/Flag.svc/UnFlagtalk"
#define DELETE_TALK @"MyFinds/manage/ManageMyFinds.svc/DeleteMyFind"
#define CHECK_IF_ADDTALK @"http://184.172.250.60/rest1.1/MyFinds/AddTalks/AddTalk.svc/addTalk/"
#define ADD_FOOD_TALK @"MyFinds/AddTalks/AddTalk.svc/addTalk/category=1"
#define ADD_SERVICE_TALK @"MyFinds/AddTalks/AddTalk.svc/addTalk/category=4"
#define ADD_EVENT_TALK @"MyFinds/AddTalks/AddTalk.svc/addTalk/category=3"
#define ADD_SHOPPING_TALK @"MyFinds/AddTalks/AddTalk.svc/addTalk/category=2"
#define ADD_NIGHTLIFE_TALK @"MyFinds/AddTalks/AddTalk.svc/addTalk/category=5"
#define ADD_CONCIERGE_TALK @"MyFinds/AddTalks/AddTalk.svc/addTalk/category=6"
#define EDIT_FOOD_TALK @"MyFinds/AddTalks/AddTalk.svc/editTalk/category=1"
#define EDIT_SERVICE_TALK @"MyFinds/AddTalks/AddTalk.svc/editTalk/category=4"
#define EDIT_EVENT_TALK @"MyFinds/AddTalks/AddTalk.svc/editTalk/category=3"
#define EDIT_SHOPPING_TALK @"MyFinds/AddTalks/AddTalk.svc/editTalk/category=2"
#define EDIT_NIGHTLIFE_TALK @"MyFinds/AddTalks/AddTalk.svc/editTalk/category=5"
#define EDIT_CONCIERGE_TALK @"MyFinds/AddTalks/AddTalk.svc/editTalk/category=6"
#define SUBMIT_FIND @"MyFinds/manage/ManageMyFinds.svc/SubmitMyFind"
// WUTZWHAT
#define GET_WUTZWHAT_LIST @"Feeds/wutzwat/GetWutzWhatList.svc/getwutzwattalks"
#define GET_WUTZWHAT_HOTPICKS_DETAIL @"Feeds/wutzwat/GetWutzwatDetail.svc/getwutzwatdetail"
#define GET_WUTZWHAT_OTHER_LOCATIONS @"Feeds/General/GetLocations.svc/getlocations"
#define GET_WUTZWHAT_REVIEWS @"Feeds/General/GetReviews.svc/getreviews"
#define WUTZWHAT_FEEDBACK @"UserResponse/Perks_WutzWhat/FeedBack.svc/addFeedBack"
#define CHECKIN_WUTZWHAT @"UserResponse/Perks_WutzWhat/checkin.svc/checkin"
#define WUTZWHAT_HOTPICKS_LIKE_FAV_SHARE @"UserResponse/Perks_WutzWhat/UserFeedback.svc/userfeedback"

#define WUTZWHAT_FILTER @"wutzwhat_filter"


//PERKS
#define GET_PERK_DETAILS @"Feeds/perks/GetPerkDetails.svc/PerkDetail"
#define GET_PERKS_LIST @"Feeds/perks/GetPerkList.svc/PerkList"
#define RELATED_PERKS @"Feeds/perks/GetRelatedPerkList.svc/RelatedPerkList"


#define PERK_ID_FOR_REVIEW 2
#define WUTZWHAT_ID_FOR_REVIEW 1
#define HOTPICKS_ID_FOR_REVIEW 3
#define MYFINDS_ID_FOR_REVIEW 4


//NOTIFICATIONS

#define GET_NOTIFICATION_SETTINGS @"Notifications/Feeds/GetSettings.svc/getsettings"
#define SET_NOTIFICATION_SETTINGS @"Notifications/Settings/EditSettings.svc/edit"
#define SET_NOTIFICATION_AS_READ @"Notifications/Settings/EditSettings.svc/markRead"
#define EDIT_DEVICE_TOKEN @"Notifications/Settings/EditDeviceTokens.svc/edit"
#define NOTIFICATION_TOKEN_SENT_FLAG @"token_sent"
#define GET_NOTIFICATION_LIST @"Notifications/Feeds/List.svc/notifications"

//CREDITS

#define GET_CREDIT_BALANCE @"Feeds/credits/GetCreditInfo.svc/getbalance"
#define GET_CREDIT_HISTORY @"Feeds/credits/GetCreditInfo.svc/getcredithistory"
#define GET_PROMO_CODE @"Promos/Redeem.svc/redeemPromoCode"
#define SPREAD_WUTZWHAT @"Accounts/Accounts.svc/get_referral_link"
#define GET_MYPERKS_LIST @"Feeds/perks/GetMyPerks.svc/MyPerkList"

//FAV
#define GET_FAVORITES_LIST @"Feeds/wutzwat/GetWutzwhatFavoriteList.svc/WutzwhatFavoriteList"
#define GET_PERKSFAVORITES_LIST @"Feeds/perks/GetPerkFavouriteList.svc/PerkFavoriteList"

//Hud
#define HUD_IMAGE @"done.png"
#define HUD_IMAGE_FAIL @"failed.png"

//Payments

#define ADD_CARD_TO_USER_ACCOUNT @"Payments/AddCard.svc/AddCard"
#define GET_CARD_INFO @"Payments/GetCardInfo.svc/GetCardInfo"
#define DELETE_USER_CARD @"Payments/DeleteCard.svc/DeleteCard"
#define SET_USER_DEFAULT_CARD @"Payments/DeleteCard.svc/SetDefault"
#define GET_TAX_INFO @"Payments/GetTaxInfo.svc/PurchaseInfo"
#define UPDATE_SHIPPING_ADDRESS @"Payments/UpdateAddress.svc/UpdateAddress"
#define MAKE_PAYMENT @"Payments/ConfirmPayment.svc/ConfirmPayment"// @"Payments/ConfirmPayment.svc/ConfirmPayment"
#define GET_PDF_RECEIPT @"Payments/GetReceiptPdf.svc/GetReceipt"

#define PAYMENT_PUBLIC_KEY @"MIIBCgKCAQEAukvxVje8wLw694+GkwQFHCzOBZCClTRwXjWNEhLeTmTedRkMiT1nBjS2jjusyRXrVR+lleNSdvzDF6LJ97vJ+ieSIvc04q44vf6HCjlA/EwsPTb4drZxY1EP02ly0ZBiedA1xYqQfHeTodIGva7c0ODL51YHZ1IME1WWC73LpD0iNVKdGnBPYAaqO4ShZrX1qnxcmJEQE8kMVT3H9sONUBd6xrt3XRnycOzuetESdw8CeonXTeZQKBfKyokmQYvFiZqdbDSAf7ULgBteO6VNRwx0T2iycKrQ/ucFyqXAneXEMPdFdLckRb6+ToCej8/Www+EpGc+NSCuB4fnB/eP7wIDAQAB"


//For Guest User

#define GUEST_USER_TOKEN @"guest"

#define PAYMENT_OPTION_DEFAULT @"Please Select"
#define PAYMENT_OPTION_SHIPPING @"Shipping"
#define PAYMENT_OPTION_PICKUP @"Pickup"

#define GOOGLE_ADRESS_API @"http://maps.googleapis.com/maps/api/geocode/json?sensor=true&address="

#define CURRENT_CITY [[NSUserDefaults standardUserDefaults] objectForKey:@"cityselected"]

#define TORONTO_LATITUDE 43.653226
#define TORONTO_LONGITUDE -79.383184

#define NEW_YARK_LATITUDE 40.7143528
#define NEW_YARK_LONGITUDE -74.0059731

#define LA_LATITUDE 40.7143528
#define LA_LONGITUDE -74.0059731

#define ALPHA_NUMERIC_REGULAR_EXPRESSION  @"^[a-zA-Z0-9_\n ]*$"
#define NUMERIC_REGULAR_EXPRESSION @"^[0-9]+$"
#define PRICE_REGULAR_EXPRESSION @"^[0-9]*.?[0-9]+$"


#define MODULE_PERKS @"PERKS"
#define MODULE_WUTZWHAT @"WUTZWHAT"
#define MODULE_HOTPICKS @"HOTPICKS"

#define CATEGORY_FOOD @"FOOD"
#define CATEGORY_SHOPPING @"SHOPPING"
#define CATEGORY_EVENT @"EVENT"
#define CATEGORY_NIGHT_LIFE @"NIGHT_LIFE"
#define CATEGORY_SERVICES @"SERVICES"
#define CATEGORY_CONCEIRGE_HOTEL @"CONCEIRGE_HOTEL"
#define CATEGORY_CONCEIRGE_CHAUFFEUR @"CONCEIRGE_CHAUFFEUR"

#define CACHE_IMAGES_PATH @"cachedImages"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define LIST_CELL_HEADER_DATE_FORMATE @"EEEE MMMM dd"
#define LIST_CELL_DATE_FORMATE @"MMM dd"
#define ADD_MY_FIND_DATE_FORMATE @"MM/dd/yyyy HH:mm:ss"

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define DEVICE_CAN_SEND_SMS [MFMessageComposeViewController canSendText]

#define EMAIL_VALIDATION_REGULAR_EXPRESSION @"(?:[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

#define FIRST_LOGIN [[NSUserDefaults standardUserDefaults] objectForKey:@"firstLogin"]
#define FIRST_LOGIN_TOUR_FINISHED [[NSUserDefaults standardUserDefaults] objectForKey:@"firstLoginTourDone"]
#define DEFAULT_SORTING_VALUE [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultSorting"]
#define SET_DEFAULT_SORTING(i) [[NSUserDefaults standardUserDefaults] setInteger:i forKey:@"defaultSorting"]