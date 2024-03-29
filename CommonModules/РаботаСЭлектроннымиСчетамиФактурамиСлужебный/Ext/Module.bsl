﻿
#Область СлужебныйПрограммныйИнтерфейс

// Отправка отчета, получение ответа в виде ссылки и переход по ссылке в личный кабинет
//
// Параметры:
//	ДанныеОтправки - Структура - параметры для отправки отчета
//		*ИНН - Строка - ИНН организации
//		*СтрJSON - ЗаписьJSON - JSON файл с данными отчета
// 		*Код_service_id - Число - код service id
//
Процедура ОткрытьЛичныйКабинет(ДанныеОтправки) Экспорт
	
	ПараметрыСоединения = ПараметрыСоединения("https://report.1c-cloud.kg/report/create?inn=" 
												+ ДанныеОтправки.ИНН 
												+ Service_id_Документа(ДанныеОтправки.Код_service_id));
									
	HTTPСоединение = Новый HTTPСоединение(ПараметрыСоединения.Хост, ПараметрыСоединения.Порт,,,, 10, ПараметрыСоединения.ssl);
	
	HTTPЗапрос = Новый HTTPЗапрос(ПараметрыСоединения.ПутьНаСервере, ПараметрыСоединения.Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ДанныеОтправки.СтрJSON, "UTF-8");
	
	HTTPОтвет = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);

	ОшибкаЕсть = ПроверитьКодСостоянияОтвета(HTTPОтвет.КодСостояния);
	
	Если ОшибкаЕсть Тогда
		Возврат;		
	КонецЕсли;	
	
	Ответ = HTTPОтвет.ПолучитьТелоКакСтроку("UTF-8");
	
	СимволURL = СтрНайти(Ответ, "http");
	
	Если СимволURL = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не получен путь для перехода в личный кабинет. Обратитесь к администратору.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;	
	
	ПолныйURL = "";
	
	Пока Сред(Ответ, СимволURL, 1) <> """" Цикл
		ПолныйURL = ПолныйURL + Сред(Ответ, СимволURL, 1);
		СимволURL = СимволURL + 1;
	КонецЦикла;	
	
	Попытка	
		ПерейтиПоНавигационнойСсылке(ПолныйURL)
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось перейти в личный кабинет по ссылке. Обратитесь к администратору.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);			
	КонецПопытки

КонецПроцедуры

// Возвращает строку service id для определенного отчета
//
// Параметры:
//	Код_service_id - Число - код service id
//
// Возвращаемое значение:
//	Строка - Строка service id отчета
//
Функция Service_id_Документа(Код_service_id)

	// 1 - Отчет по социальному фонду
	Если Код_service_id = 1 Тогда
		Возврат "&service_id=a1d6e8fc-931e-40fe-a748-e3c355bd6418";	
	КонецЕсли;	

КонецФункции

// Возвращает разделенные данные URI
//
// Параметры:
//	СтрокаURI - Строка - полная ссылка
//
// Возвращаемое значение:
//	Структура - разделенные данные URI
//
Функция ПараметрыСоединения(Знач СтрокаURI)

	СтрокаURI = СокрЛП(СтрокаURI);
	
	// схема
	Схема = "";
	Позиция = Найти(СтрокаURI, "://");
	Если Позиция > 0 Тогда
		Схема = НРег(Лев(СтрокаURI, Позиция - 1));
		СтрокаURI = Сред(СтрокаURI, Позиция + 3);
	КонецЕсли;
	
	// строка соединения и путь на сервере
	СтрокаСоединения = СтрокаURI;
	ПутьНаСервере = "";
	Позиция = Найти(СтрокаСоединения, "/");
	Если Позиция > 0 Тогда
		ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
		СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
	КонецЕсли;
	
	// информация пользователя и имя сервера
	СтрокаАвторизации = "";
	ИмяСервера = СтрокаСоединения;
	Позиция = Найти(СтрокаСоединения, "@");
	Если Позиция > 0 Тогда
		СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
		ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
	КонецЕсли;
	
	// логин и пароль
	Логин = СтрокаАвторизации;
	Пароль = "";
	Позиция = Найти(СтрокаАвторизации, ":");
	Если Позиция > 0 Тогда
		Логин = Лев(СтрокаАвторизации, Позиция - 1);
		Пароль = Сред(СтрокаАвторизации, Позиция + 1);
	КонецЕсли;
	
	// хост и порт
	Хост = ИмяСервера;
	Порт = "";
	Позиция = Найти(ИмяСервера, ":");
	Если Позиция > 0 Тогда
		Хост = Лев(ИмяСервера, Позиция - 1);
		Порт = Сред(ИмяСервера, Позиция + 1);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Схема", Схема);
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("Хост", Хост);
	Результат.Вставить("Порт", ?(Порт <> "", Число(Порт), Неопределено));
	Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
	
	Результат.Вставить("ssl", Новый ЗащищенноеСоединениеOpenSSL(
						        Новый СертификатКлиентаWindows(СпособВыбораСертификатаWindows.Выбирать),
						        Новый СертификатыУдостоверяющихЦентровWindows()));
								
	Заголовки = Новый Соответствие();
	Заголовки.Вставить("Content-Type", "application/json");
	
	Результат.Вставить("Заголовки", Заголовки); 								
								
	Возврат Результат;	
КонецФункции

// Возвращает признак ошибки
//
// Параметры:
//	КодСостояния - Число - код состояния ответа
//
// Возвращаемое значение:
//	Булево - если есть ошибка, то ИСТИНА, если нет то ЛОЖЬ
//
Функция ПроверитьКодСостоянияОтвета(КодСостояния)

	Отказ = Ложь;
	
	Если КодСостояния = 401 Тогда
		ТекстСообщения = НСтр("ru = 'При обработке ответа сервиса произошла: ошибка аутентификации.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		
	ИначеЕсли КодСостояния = 429 Тогда
		ТекстСообщения = НСтр("ru = 'При обработке ответа сервиса произошла: превышено количество запросов к сервису.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		
	ИначеЕсли КодСостояния = 500 ИЛИ КодСостояния = 502 Тогда
		ТекстСообщения = НСтр("ru = 'При обработке ответа сервиса произошла: внутренняя ошибка сервиса.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,,,Отказ);	
	КонецЕсли;
	
	Возврат Отказ;
КонецФункции 

#КонецОбласти
