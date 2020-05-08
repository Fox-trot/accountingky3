﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает файл из Интернета по протоколу http(s), либо ftp и сохраняет его по указанному пути на сервере.
//
// Параметры:
//   URL                - Строка - url файла в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>.
//   ПараметрыПолучения - см. ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла.
//   ЗаписыватьОшибку   - Булево - Признак необходимости записи ошибки в журнал регистрации при получении файла.
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * Статус            - Булево - результат получения файла.
//      * Путь   - Строка   - путь к файлу на сервере, ключ используется только если статус Истина.
//      * СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь.
//      * Заголовки         - Соответствие - см. в синтакс-помощнике описание параметра Заголовки объекта HTTPОтвет.
//      * КодСостояния      - Число - Добавляется при возникновении ошибки.
//                                    См. в синтакс-помощнике описание параметра КодСостояния объекта HTTPОтвет.
//
Функция СкачатьФайлНаСервере(Знач URL, ПараметрыПолучения = Неопределено, Знач ЗаписыватьОшибку = Истина) Экспорт
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "Сервер");
	
	Возврат ПолучениеФайловИзИнтернетаСлужебный.СкачатьФайл(URL,
		ПараметрыПолучения, НастройкаСохранения, ЗаписыватьОшибку);
	
КонецФункции

// Получает файл из Интернета по протоколу http(s), либо ftp и сохраняет его во временное хранилище.
// Примечание: после получения файла временное хранилище необходимо самостоятельно очистить
// при помощи метода УдалитьИзВременногоХранилища. Если этого не сделать, то файл будет находиться
// в памяти сервера до конца сеанса.
//
// Параметры:
//   URL                - Строка - url файла в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>.
//   ПараметрыПолучения - см. ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла.
//   ЗаписыватьОшибку   - Булево - признак необходимости записи ошибки в журнал регистрации при получении файла.
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * Статус            - Булево - результат получения файла.
//      * Путь              - Строка   - адрес временного хранилища с двоичными данными файла,
//                            ключ используется, только если статус Истина.
//      * СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь.
//      * Заголовки         - Соответствие - см. в синтакс-помощнике описание параметра Заголовки объекта HTTPОтвет.
//      * КодСостояния      - Число - Добавляется при возникновении ошибки.
//                                    См. в синтакс-помощнике описание параметра КодСостояния объекта HTTPОтвет.
//
Функция СкачатьФайлВоВременноеХранилище(Знач URL, ПараметрыПолучения = Неопределено, Знач ЗаписыватьОшибку = Истина) Экспорт
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "ВременноеХранилище");
	
	Возврат ПолучениеФайловИзИнтернетаСлужебный.СкачатьФайл(URL,
		ПараметрыПолучения, НастройкаСохранения, ЗаписыватьОшибку);
	
КонецФункции

// Возвращает настройку прокси-сервера для доступа в Интернет со стороны
// клиента для текущего пользователя.
//
// Возвращаемое значение:
//   Соответствие - свойства:
//		ИспользоватьПрокси - использовать ли прокси-сервер.
//		НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов.
//		ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера.
//		Сервер       - адрес прокси-сервера.
//		Порт         - порт прокси-сервера.
//		Пользователь - имя пользователя для авторизации на прокси-сервере.
//		Пароль       - пароль пользователя.
//
Функция НастройкиПроксиНаКлиенте() Экспорт
	
	ИмяПользователя = Неопределено;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		// В файловом режиме регламентные задания выполняются на том же компьютере,
		// на котором выполняется работа пользователя.
		
		ТекущийСеансИнформационнойБазы = ПолучитьТекущийСеансИнформационнойБазы();
		ФоновоеЗадание = ТекущийСеансИнформационнойБазы.ПолучитьФоновоеЗадание();
		ЭтоСеансРегламентногоЗадания = ФоновоеЗадание <> Неопределено И ФоновоеЗадание.РегламентноеЗадание <> Неопределено;
		
		Если ЭтоСеансРегламентногоЗадания Тогда
			
			Если Не ЗначениеЗаполнено(ФоновоеЗадание.РегламентноеЗадание.ИмяПользователя) Тогда 
				
				// Если регламентное задание выполняется от имени пользователя по умолчанию,
				// то следует взять настройки прокси из сохраненных настроек пользователя,
				// на компьютере которого запущен текущий сеанс регламентного задания.
				
				Сеансы = ПолучитьСеансыИнформационнойБазы(); // Массив из СеансИнформационнойБазы
				Для Каждого Сеанс Из Сеансы Цикл 
					Если Сеанс.ИмяКомпьютера = ТекущийСеансИнформационнойБазы.ИмяКомпьютера Тогда 
						ИмяПользователя = Сеанс.Пользователь.Имя;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкаПроксиСервера", "",,, ИмяПользователя);
	
КонецФункции

// Возвращает параметры настройки прокси-сервера на стороне сервера 1С:Предприятия.
//
// Возвращаемое значение:
//   Соответствие - свойства:
//		ИспользоватьПрокси - использовать ли прокси-сервер.
//		НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов.
//		ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера.
//		Сервер       - адрес прокси-сервера.
//		Порт         - порт прокси-сервера.
//		Пользователь - имя пользователя для авторизации на прокси-сервере.
//		Пароль       - пароль пользователя.
//
Функция НастройкиПроксиНаСервере() Экспорт
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат НастройкиПроксиНаКлиенте();
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		НастройкиПроксиНаСервере = Константы.НастройкаПроксиСервера.Получить().Получить();
		Возврат ?(ТипЗнч(НастройкиПроксиНаСервере) = Тип("Соответствие"),
			НастройкиПроксиНаСервере,
			Неопределено);
	КонецЕсли;
	
КонецФункции

// Возвращает объект ИнтернетПрокси для доступа в Интернет.
// Допустимые протоколы для создания ИнтернетПрокси http, https, ftp и ftps.
//
// Параметры:
//    URLИлиПротокол - Строка - url в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>,
//                              либо идентификатор протокола (http, ftp, ...).
//
// Возвращаемое значение:
//    ИнтернетПрокси - описывает параметры прокси-серверов для различных протоколов.
//                     Если не удалось распознать схему сетевой протокол,
//                     то будет создать прокси на основании протокола HTTP.
//
Функция ПолучитьПрокси(Знач URLИлиПротокол) Экспорт
	
	ДопустимыеПротоколы = Новый Соответствие();
	ДопустимыеПротоколы.Вставить("HTTP",  Истина);
	ДопустимыеПротоколы.Вставить("HTTPS", Истина);
	ДопустимыеПротоколы.Вставить("FTP",   Истина);
	ДопустимыеПротоколы.Вставить("FTPS",  Истина);
	
	НастройкаПроксиСервера = НастройкиПроксиНаСервере();
	
	Если СтрНайти(URLИлиПротокол, "://") > 0 Тогда
		СтруктураURL = ОбщегоНазначенияКлиентСервер.СтруктураURI(URLИлиПротокол);
		Протокол = ?(ПустаяСтрока(СтруктураURL.Схема), "http", СтруктураURL.Схема);
	Иначе
		Протокол = НРег(URLИлиПротокол);
	КонецЕсли;
	
	Если ДопустимыеПротоколы[ВРег(Протокол)] = Неопределено Тогда
		Протокол = "HTTP";
	КонецЕсли;
	
	Возврат ПолучениеФайловИзИнтернетаСлужебный.НовыйИнтернетПрокси(НастройкаПроксиСервера, Протокол);
	
КонецФункции

// Запускает диагностику сетевого ресурса.
// В модели сервиса возвращается только описание ошибки.
//
// Параметры:
//  URL - Строка - адрес URL ресурса, диагностику которого надо выполнить.
//
// Возвращаемое значение:
//  Структура - результат диагностики:
//    *  ОписаниеОшибки    - Строка - краткое описание ошибки.
//    *  ЖурналДиагностики - Строка - подробный журнал диагностики с техническими подробностями.
//
// Пример:
//	// Диагностика веб-сервиса адресного классификатора.
//	Результат = ОбщегоНазначенияКлиентСервер.ДиагностикаСоединения("https://api.orgaddress.1c.com/orgaddress/v1?wsdl");
//	
//	ОписаниеОшибки    = Результат.ОписаниеОшибки;
//	ЖурналДиагностики = Результат.ЖурналДиагностики;
//
Функция ДиагностикаСоединения(URL) Экспорт
	
	Описание = Новый Массив;
	Описание.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'При обращении по URL: %1'"), 
		URL));
	Описание.Добавить(ПолучениеФайловИзИнтернетаСлужебный.ПредставлениеМестаДиагностики());
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Описание.Добавить(
			НСтр("ru = 'Обратитесь к администратору.'"));
		
		ОписаниеОшибки = СтрСоединить(Описание, Символы.ПС);
		
		Результат = Новый Структура;
		Результат.Вставить("ОписаниеОшибки", ОписаниеОшибки);
		Результат.Вставить("ЖурналДиагностики", "");
		
		Возврат Результат;
	КонецЕсли;
	
	Журнал = Новый Массив;
	Журнал.Добавить(
		НСтр("ru = 'Журнал диагностики:
		           |Выполняется проверка доступности сервера.
		           |Описание диагностируемой ошибки см. в следующем сообщении журнала.'"));
	Журнал.Добавить();
	
	СостояниеНастроекПрокси = ПолучениеФайловИзИнтернетаСлужебный.СостояниеНастроекПрокси();
	СоединениеЧерезПрокси = СостояниеНастроекПрокси.СоединениеЧерезПрокси;
	Журнал.Добавить(СостояниеНастроекПрокси.Представление);
	
	Если СоединениеЧерезПрокси И Не СостояниеНастроекПрокси.ИспользуютсяСистемныеНастройкиПрокси Тогда 
		
		Описание.Добавить(
			НСтр("ru = 'Диагностика соединения не выполнена, т.к. настроен прокси-сервер.
			           |Обратитесь к администратору.'"));
		
	Иначе 
		
		СтруктураСсылки = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
		АдресСервераРесурса = СтруктураСсылки.Хост;
		АдресСервераКонтрольнойПроверки = "1c.com";
		
		РезультатДоступностиРесурса = ПолучениеФайловИзИнтернетаСлужебный.ПроверитьДоступностьСервера(АдресСервераРесурса);
		
		Журнал.Добавить();
		Журнал.Добавить("1) " + РезультатДоступностиРесурса.ЖурналДиагностики);
		
		Если РезультатДоступностиРесурса.Доступен Тогда 
			
			Описание.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Выполнено обращение к несуществующему ресурсу на сервере %1
				           |или возникли неполадки на удаленном сервере.'"),
				АдресСервераРесурса));
			
		Иначе 
			
			РезультатКонтрольнойПроверки = ПолучениеФайловИзИнтернетаСлужебный.ПроверитьДоступностьСервера(АдресСервераКонтрольнойПроверки);
			Журнал.Добавить("2) " + РезультатКонтрольнойПроверки.ЖурналДиагностики);
			
			Если Не РезультатКонтрольнойПроверки.Доступен Тогда
				
				Описание.Добавить(
					НСтр("ru = 'Отсутствует доступ в сеть интернет по причине:
					           |- компьютер не подключен к интернету;
					           |- неполадки у интернет-провайдера;
					           |- подключение к интернету блокирует межсетевой экран, 
					           |  антивирусная программа или другое программное обеспечение.'"));
				
			Иначе 
				
				Описание.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сервер %1 не доступен по причине:
					           |- неполадки у интернет-провайдера;
					           |- подключение к серверу блокирует межсетевой экран, 
					           |  антивирусная программа или другое программное обеспечение;
					           |- сервер отключен или на техническом обслуживании.'"),
					АдресСервераРесурса));
				
				ЖурналТрассировки = ПолучениеФайловИзИнтернетаСлужебный.ЖурналТрассировкиМаршрутаСервера(АдресСервераРесурса);
				Журнал.Добавить("3) " + ЖурналТрассировки);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОписаниеОшибки = СтрСоединить(Описание, Символы.ПС);
	
	Журнал.Вставить(0);
	Журнал.Вставить(0, ОписаниеОшибки);
	
	ЖурналДиагностики = СтрСоединить(Журнал, Символы.ПС);
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Диагностика соединения'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,,, ЖурналДиагностики);
	
	Результат = Новый Структура;
	Результат.Вставить("ОписаниеОшибки", ОписаниеОшибки);
	Результат.Вставить("ЖурналДиагностики", ЖурналДиагностики);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
