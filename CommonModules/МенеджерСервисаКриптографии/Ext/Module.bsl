﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Менеджер сервиса криптографии".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ЗаявлениеНаПодключение

// Функция - Отправить заявление на подключение
//
// Параметры:
//  Заявление - Структура - заявление.
// 
// Возвращаемое значение:
//  Структура - результат.
//
Функция ОтправитьЗаявлениеНаПодключение(Заявление) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/requests/%1/request_sender", ВерсияПрограммногоИнтерфейса_v2_0());
	
	ПараметрыЗапроса = Заявление;
	ПараметрыЗапроса.Вставить("client", ПолучитьОписаниеКлиента());
	
	ПоляОтвета = Новый Структура("req_id", "Идентификатор");
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);

КонецФункции

// Функция - Сформировать заявление для подписания
//
// Параметры:
//  Заявление - Структура - заявление.
// 
// Возвращаемое значение:
//  Структура - результат.
//
Функция СформироватьЗаявлениеДляПодписания(Заявление) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/requests/%1/request", ВерсияПрограммногоИнтерфейса_v2_0());
	
	ПараметрыЗапроса = Заявление;
	ПараметрыЗапроса.Вставить("client", ПолучитьОписаниеКлиента());
	
	ПоляОтвета = Новый Структура("req_id, request", "Идентификатор", "Заявление");
	ПараметрыПреобразования = Новый Структура("ИменаСвойствДляВосстановления", СтрРазделить("request", ","));
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета,, ПараметрыПреобразования);

КонецФункции

// Функция - Отправить подписанное заявление
//
// Параметры:
//  Заявление - Структура - заявление.
// 
// Возвращаемое значение:
//  Структура - результат.
//
Функция ОтправитьПодписанноеЗаявление(Заявление) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/requests/%1/signed_request_sender", ВерсияПрограммногоИнтерфейса_v2_0());
	
	ПараметрыЗапроса = Заявление;
	ПараметрыЗапроса.Вставить("client", ПолучитьОписаниеКлиента());
	
	ПоляОтвета = Новый Структура;
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);

КонецФункции

// Функция - Получить статус заявления на подключение
//
// Параметры:
//  ИдентификаторЗаявления - Строка - идентификатор заявления.
// 
// Возвращаемое значение:
//  Структура - результат.
//
Функция ПолучитьСтатусЗаявленияНаПодключение(ИдентификаторЗаявления) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/requests/%1/request/%2",
										ВерсияПрограммногоИнтерфейса_v1_1(),
										ИдентификаторЗаявления);
										
	ПоляОтвета = Новый Структура("status,details", "Статус", "Пояснение");
	
	Возврат ВызватьHTTPМетод("GET", URL, Неопределено, ПоляОтвета);

КонецФункции

#КонецОбласти

#Область ПроверкаТелефонаИЭлектроннойПочты

// Функция - Получить код проверки телефона
//
// Параметры:
//  Телефон - Строка - телефон,
//  Идентификатор - Строка - идентификатор.
// 
// Возвращаемое значение:
//  Структура - результат.
//
Функция ПолучитьКодПроверкиТелефона(Телефон, Идентификатор = "") Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/verification/%1/phone/code", ВерсияПрограммногоИнтерфейса_v1_1());
	
	ПараметрыЗапроса = Новый Структура("phone,req_id,repeat", Телефон, Идентификатор, ЗначениеЗаполнено(Идентификатор));
	
	ПоляОтвета = Новый Структура;
	ПоляОтвета.Вставить("req_id", "Идентификатор");
	ПоляОтвета.Вставить("num", "НомерКода");
	ПоляОтвета.Вставить("life_time", "ВремяДействияКода");
	ПоляОтвета.Вставить("delay", "ЗадержкаПередПовторнойОтправкой");
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);

КонецФункции

// Функция - Проверить телефон по коду
//
// Параметры:
//  Идентификатор - Строка - идентификатор,
//  Код - Строка - код.
// 
// Возвращаемое значение:
//  Структура - результат.
//
Функция ПроверитьТелефонПоКоду(Идентификатор, Код) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/verification/%1/phone", ВерсияПрограммногоИнтерфейса_v1_1());
	
	ПараметрыЗапроса = Новый Структура("req_id,code", Идентификатор, Код);
	
	ПоляОтвета = Новый Структура;
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);
	
КонецФункции

// Функция - Получить код проверки электронной почты
//
// Параметры:
//  ЭлектроннаяПочта - Строка - электронная почта,
//  Идентификатор - Строка - идентификатор.
// 
// Возвращаемое значение:
//  Структура - результат.
//
Функция ПолучитьКодПроверкиЭлектроннойПочты(ЭлектроннаяПочта, Идентификатор = "") Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/verification/%1/email/code", ВерсияПрограммногоИнтерфейса_v1_1());
	
	ПараметрыЗапроса = Новый Структура("email,req_id,repeat", ЭлектроннаяПочта, Идентификатор, ЗначениеЗаполнено(Идентификатор));
	
	ПоляОтвета = Новый Структура;
	ПоляОтвета.Вставить("req_id", "Идентификатор");
	ПоляОтвета.Вставить("num", "НомерКода");
	ПоляОтвета.Вставить("life_time", "ВремяДействияКода");
	ПоляОтвета.Вставить("delay", "ЗадержкаПередПовторнойОтправкой");
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);
	
КонецФункции

// Функция - Проверить электронную почту по коду
//
// Параметры:
//  Идентификатор - Строка - идентификатор,
//  Код - Строка - код.
// 
// Возвращаемое значение:
//  Структура - результат.
//
Функция ПроверитьЭлектроннуюПочтуПоКоду(Идентификатор, Код) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/verification/%1/email", ВерсияПрограммногоИнтерфейса_v1_1());
	
	ПараметрыЗапроса = Новый Структура("req_id,code", Идентификатор, Код);
	
	ПоляОтвета = Новый Структура;
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);

КонецФункции

#КонецОбласти

#Область ИзменениеНастроекПолученияВременныхПаролейПровайдером

// Функция - Напечатать заявление
//
// Параметры:
//  ИдентификаторЗаявления - Строка - идентификатор заявления,
//  ИдентификаторПроверки - Строка - идентификатор проверки,
//  ИдентификаторСертификата - Строка - идентификатор сертификата.
// 
// Возвращаемое значение:
//  Структура - результат.
//
Функция НапечататьЗаявление(ИдентификаторЗаявления, ИдентификаторПроверки, ИдентификаторСертификата) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/phone/request/%2",
										ВерсияПрограммногоИнтерфейса_v1_1(),
										ИдентификаторЗаявления);
										
	ПараметрыЗапроса = Новый Структура("client", ПолучитьОписаниеКлиента());
	ПараметрыЗапроса.Вставить("phone", ИдентификаторПроверки);
	ПараметрыЗапроса.Вставить("cert_id", ИдентификаторСертификата);
	
	Результат = ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, Новый Структура);
	Если Результат.Выполнено Тогда
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("mxl");
		Результат.Файл.Записать(ИмяВременногоФайла);
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Прочитать(ИмяВременногоФайла);
		
		УдалитьФайлы(ИмяВременногоФайла);
		
		Результат.Файл = ТабличныйДокумент;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция - Отправить заявление
//
// Параметры:
//  ИдентификаторЗаявления - Строка - идентификатор заявления,
//  ФайлЗаявления - Строка - файл заявления.
// 
// Возвращаемое значение:
//  Структура - результат.
//
Функция ОтправитьЗаявление(ИдентификаторЗаявления, ФайлЗаявления) Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/phone/request/%2",
										ВерсияПрограммногоИнтерфейса_v1_1(),
										ИдентификаторЗаявления);
										
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Disposition", 
		СтрШаблон("attachment; filename=%1", КодироватьСтроку(ФайлЗаявления.Имя, СпособКодированияСтроки.КодировкаURL)));
		
	Результат = ВызватьHTTPМетод("PUT", URL, ПолучитьИзВременногоХранилища(ФайлЗаявления.Адрес), Новый Структура, Заголовки);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ИзменениеНастроекПолученияВременныхПаролейПользователем

// Функция - Начать изменение настроек получения временных паролей
//
// Параметры:
//  ИдентификаторСертификата - Строка - идентификатор сертификата,
//  Телефон - Строка - телефон,
//  ЭлектроннаяПочта - Строка - электронная почта,
//  Идентификатор - Строка - идентификатор.
// 
// Возвращаемое значение:
//  Структура - результат.
//
Функция НачатьИзменениеНастроекПолученияВременныхПаролей(ИдентификаторСертификата, Телефон, ЭлектроннаяПочта, Идентификатор = "") Экспорт
	
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/users_requests", ВерсияПрограммногоИнтерфейса_v1_1());
	
	ПараметрыЗапроса = Новый Структура("client", ПолучитьОписаниеКлиента());
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		ПараметрыЗапроса.Вставить("req_id", Идентификатор);
	Иначе
		ПараметрыЗапроса.Вставить("cert_id", ИдентификаторСертификата);
		Если Телефон <> Неопределено Тогда
			ПараметрыЗапроса.Вставить("phone", Телефон);
		КонецЕсли;
		Если ЭлектроннаяПочта <> Неопределено Тогда
			ПараметрыЗапроса.Вставить("email", ЭлектроннаяПочта);
		КонецЕсли;
	КонецЕсли;

	ПоляОтвета = Новый Структура("req_id,life_time,delay", "Идентификатор", "ВремяДействияКода", "ЗадержкаПередПовторнойОтправкой");
	
	Возврат ВызватьHTTPМетод("POST", URL, ПараметрыЗапроса, ПоляОтвета);
	
КонецФункции

// Функция - Завершить изменение настроек получения временных паролей
//
// Параметры:
//  Идентификатор - Строка - идентификатор,
//  Код - Строка - код.
// 
// Возвращаемое значение:
//  Структура - результат.
//
Функция ЗавершитьИзменениеНастроекПолученияВременныхПаролей(Идентификатор, Код) Экспорт
			
	URL = АдресСервиса() + СтрШаблон("/hs/otp/%1/user_request/%2", ВерсияПрограммногоИнтерфейса_v1_1(), Идентификатор);
										
	ПараметрыЗапроса = Новый Структура("req_id,code", Идентификатор, Код);
	
	Возврат ВызватьHTTPМетод("PUT", URL, ПараметрыЗапроса, Новый Структура);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьОписаниеКлиента()
	
	ОписаниеКлиента = Новый Структура;
	ОписаниеКлиента.Вставить("version", Метаданные.Версия);
	ОписаниеКлиента.Вставить("name", Метаданные.Имя);
	ОписаниеКлиента.Вставить("id", Формат(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), "ЧГ="));
	
	Возврат ОписаниеКлиента;
	
КонецФункции

Функция ПолучитьПараметрыСоединения(URL) Экспорт
	
	ПараметрыСоединения = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	ПараметрыСоединения.Схема = ?(ЗначениеЗаполнено(ПараметрыСоединения.Схема), ПараметрыСоединения.Схема, "http");	
	ПараметрыСоединения.Вставить("Таймаут", 120);
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Константы.АдресСервисаПодключенияЭлектроннойПодписиВМоделиСервиса);
	ПараметрыСоединения.Вставить("Логин", ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Логин", Истина));
	ПараметрыСоединения.Вставить("Пароль", ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль", Истина));
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ПараметрыСоединения;
	
КонецФункции

Функция АдресСервиса()
	
	УстановитьПривилегированныйРежим(Истина);

	Возврат Константы.АдресСервисаПодключенияЭлектроннойПодписиВМоделиСервиса.Получить();
	
КонецФункции

Функция ВерсияПрограммногоИнтерфейса_v1_1()
	
	Возврат "v1.1";
	
КонецФункции

Функция ВерсияПрограммногоИнтерфейса_v2_0()
	
	Возврат "v2.0";
	
КонецФункции

Функция ВызватьHTTPМетод(HTTPМетод, URL, ПараметрыЗапроса, СоответствиеПолейОтвета, Заголовки = Неопределено, ПараметрыПреобразования = Неопределено)
	
	Результат = Новый Структура;	
	
	ПараметрыСоединения = ПолучитьПараметрыСоединения(URL);
	Попытка
		Соединение = ЭлектроннаяПодписьВМоделиСервиса.СоединениеССерверомИнтернета(ПараметрыСоединения);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись в модели сервиса.Менеджер сервиса криптографии'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
		Результат.Вставить("Выполнено", Ложь);
		Результат.Вставить("КодОшибки", "НеУдалосьУстановитьСоединение");
		Результат.Вставить("ОписаниеОшибки", НСтр("ru = 'Не удалось установить соединение с сервером.'"));		
	КонецПопытки;

	Запрос = Новый HTTPЗапрос(ПараметрыСоединения.ПутьНаСервере);
	Если ТипЗнч(ПараметрыЗапроса) = Тип("Структура") Тогда
		Запрос.Заголовки.Вставить("Content-Type", "application/json");
		Запрос.УстановитьТелоИзСтроки(ЭлектроннаяПодписьВМоделиСервиса.СтруктураВJson(ПараметрыЗапроса));
	ИначеЕсли ТипЗнч(ПараметрыЗапроса) = Тип("ДвоичныеДанные") Тогда
		Запрос.Заголовки.Вставить("Content-Type", "application/octet-stream");
		Запрос.УстановитьТелоИзДвоичныхДанных(ПараметрыЗапроса);
	КонецЕсли;
	Если ЗначениеЗаполнено(Заголовки) Тогда
		Для Каждого Заголовок Из Заголовки Цикл
			Запрос.Заголовки.Вставить(Заголовок.Ключ, Заголовок.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Попытка
		Ответ = Соединение.ВызватьHTTPМетод(HTTPМетод, Запрос);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись в модели сервиса.Менеджер сервиса криптографии'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
		Результат.Вставить("Выполнено", Ложь);
		Результат.Вставить("КодОшибки", "ОшибкаПриОбращенииКСерверу");
		Результат.Вставить("ОписаниеОшибки", КраткоеПредставлениеОшибки(ИнформацияОбОшибке));		
		Возврат Результат;
	КонецПопытки;

	Если Ответ.КодСостояния = 200 Тогда
		Результат.Вставить("Выполнено", Истина);
		
		ContentType = Ответ.Заголовки.Получить("Content-Type");
		
		Если (ContentType = "application/json") Или (ContentType = "application/javascript") Тогда
			ПараметрыОтвета = ЭлектроннаяПодписьВМоделиСервиса.JsonВСтруктуру(Ответ.ПолучитьТелоКакСтроку(), ПараметрыПреобразования);
			Для Каждого Поле Из СоответствиеПолейОтвета Цикл
				Если ПараметрыОтвета.Свойство(Поле.Ключ) Тогда
					Результат.Вставить(Поле.Значение, ПараметрыОтвета[Поле.Ключ]);
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли ContentType = "application/octet-stream" Тогда
			Результат.Вставить("Файл", Ответ.ПолучитьТелоКакДвоичныеДанные());
			Результат.Вставить("Имя", СтрЗаменить(Ответ.Заголовки.Получить("Content-Disposition"), "attachment; filename=", ""));
		КонецЕсли;
	ИначеЕсли Ответ.КодСостояния = 400 Тогда
		Результат.Вставить("Выполнено", Ложь);
		ПараметрыОтвета = ЭлектроннаяПодписьВМоделиСервиса.JsonВСтруктуру(Ответ.ПолучитьТелоКакСтроку());
		Результат.Вставить("КодОшибки", ПолучитьКодОшибки(ПараметрыОтвета.err_code));
		Результат.Вставить("ОписаниеОшибки", СокрЛП(ПараметрыОтвета.err_msg));
	Иначе
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронная подпись в модели сервиса.Менеджер сервиса криптографии'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, Ответ.ПолучитьТелоКакСтроку());
		Результат.Вставить("Выполнено", Ложь);
		Результат.Вставить("КодОшибки", "НеизвестнаяОшибка");
		Результат.Вставить("ОписаниеОшибки", НСтр("ru = 'Сервис временно недоступен. Обратитесь в службу поддержки или повторите попытку позже.'"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьКодОшибки(err_code)
	
	КодыОшибок = Новый Соответствие;
	КодыОшибок.Вставить("CertificateNotFound", "СертификатНеНайден");
	КодыОшибок.Вставить("RequestNotFound", "ЗаявлениеНеНайдено");
	КодыОшибок.Вставить("NewPhoneIsEqualToTheCurrent", "НовыйТелефонРавенТекущему");
	КодыОшибок.Вставить("NewEmailIsEqualToTheCurrent", "НоваяЭлектроннаяПочтаРавнаТекущей");
	КодыОшибок.Вставить("MaxAttemptsInputCodeExceeded", "ПревышенЛимитПопытокВводаКода");
	КодыОшибок.Вставить("CodeExpired", "СрокДействияКодаИстек");
	КодыОшибок.Вставить("CodeIsWrong", "КодНеверный");
	КодыОшибок.Вставить("TooFrequentCodeRequests", "СлишкомЧастыеПовторныеОтправки");
	
	КодОшибки = КодыОшибок.Получить(err_code);
	Если Не ЗначениеЗаполнено(КодОшибки) Тогда
		КодОшибки = err_code;
	КонецЕсли;
	
	Возврат КодОшибки;
	
КонецФункции

#КонецОбласти