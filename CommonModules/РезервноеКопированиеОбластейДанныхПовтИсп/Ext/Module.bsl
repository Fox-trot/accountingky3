﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает соответствие русских названий полей программных системных настроек
// английским из XDTO-пакета ZoneBackupControl Менеджера сервиса.
// (тип: {http://www.1c.ru/SaaS/1.0/XMLSchema/ZoneBackupControl}Settings).
//
// Возвращаемое значение:
//   ФиксированноеСоответствие - соответствие русских имен полей настроек английским.
//
Функция СоответствиеРусскихИменПолейНастроекАнглийским() Экспорт
	
	Результат = Новый Соответствие;
	
	Результат.Вставить("CreateDailyBackup", "ФормироватьЕжедневныеКопии");
	Результат.Вставить("CreateMonthlyBackup", "ФормироватьЕжемесячныеКопии");
	Результат.Вставить("CreateYearlyBackup", "ФормироватьЕжегодныеКопии");
	Результат.Вставить("BackupCreationTime", "ВремяФормированияКопий");
	Результат.Вставить("MonthlyBackupCreationDay", "ЧислоМесяцаФормированияЕжемесячныхКопий");
	Результат.Вставить("YearlyBackupCreationMonth", "МесяцФормированияЕжегодныхКопий");
	Результат.Вставить("YearlyBackupCreationDay", "ЧислоМесяцаФормированияЕжегодныхКопий");
	Результат.Вставить("KeepDailyBackups", "КоличествоЕжедневныхКопий");
	Результат.Вставить("KeepMonthlyBackups", "КоличествоЕжемесячныхКопий");
	Результат.Вставить("KeepYearlyBackups", "КоличествоЕжегодныхКопий");
	Результат.Вставить("CreateDailyBackupOnUserWorkDaysOnly", "ФормироватьЕжедневныеКопииТолькоВДниРаботыПользователей");
	
	Возврат Новый ФиксированноеСоответствие(Результат);

КонецФункции	

// Определяет, поддерживает ли приложение функциональность резервного копирования.
//
// Возвращаемое значение:
// Булево - Истина, если приложение поддерживает функциональность резервного копирования.
//
Функция МенеджерСервисаПоддерживаетРезервноеКопирование() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПоддерживаемыеВерсии = ОбщегоНазначения.ПолучитьВерсииИнтерфейса(
		РаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса(),
		РаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса(),
		РаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса(),
		"РезервноеКопированиеОбластейДанных");
		
	Возврат ПоддерживаемыеВерсии.Найти("1.0.1.1") <> Неопределено;
	
КонецФункции

// Возвращает прокси web-сервиса контроля резервного копирования.
// 
// Возвращаемое значение: 
//   WSПрокси - прокси менеджера сервиса.
// 
Функция ПроксиКонтроляРезервногоКопирования() Экспорт
	
	АдресМенеджераСервиса = РаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса();
	Если Не ЗначениеЗаполнено(АдресМенеджераСервиса) Тогда
		ВызватьИсключение(НСтр("ru = 'Не установлены параметры связи с менеджером сервиса.';
								|en = 'Parameters of connection with the service manager are not set.'"));
	КонецЕсли;
	
	АдресСервиса = АдресМенеджераСервиса + "/ws/ZoneBackupControl?wsdl";
	ИмяПользователя = РаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса();
	ПарольПользователя = РаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса();
	
	ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключения.АдресWSDL = АдресСервиса;
	ПараметрыПодключения.URIПространстваИмен = "http://www.1c.ru/SaaS/1.0/WS";
	ПараметрыПодключения.ИмяСервиса = "ZoneBackupControl";
	ПараметрыПодключения.ИмяПользователя = ИмяПользователя; 
	ПараметрыПодключения.Пароль = ПарольПользователя;
	ПараметрыПодключения.Таймаут = 10;
	
	Прокси = ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
	
	Возврат Прокси;
	
КонецФункции

#КонецОбласти
