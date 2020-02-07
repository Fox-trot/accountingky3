﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Контрагенты

// Возвращают реквизиты юридического лица по данным ЕГРЮЛ (наименование, адрес, коды и т.д.).
//
// Параметры:
//	ИНН - Строка - ИНН юридического лица, реквизиты которого надо получить.
//
// Возвращаемое значение:
//	Структура - реквизиты юридического лица.
//		* ИНН - Строка - ИНН юридического лица.
//		* Наименование - Строка - представление юридического лица в учетной программе.
//		* НаименованиеПолное - Строка - полное наименование юридического лица.
//		* НаименованиеСокращенное - Строка - сокращенное наименование юридического лица.
//		* ПравоваяФорма - Строка, Неопределено - правовая форма юридического лица.
//		* ЮридическийАдрес - Структура, Неопределено - данные о юридическом адресе.
//			** КонтактнаяИнформация - Строка - данные в формате JSON для заполнения реквизита
//				"Значение" контактной информации в табличной части КонтактнаяИнформация объекта
//				(см. описание подсистемы "Контактная информация" Библиотеки стандартных подсистем).
//			** Представление - Строка - представление адреса.
//			** Комментарий - Строка - произвольный комментарий.
//			** Корректный - Булево - адрес является корректным по данным ФИАС;
//		* Телефон - Структура, Неопределено - данные о телефоне.
//			** КонтактнаяИнформация - Строка - данные в формате JSON для заполнения реквизита
//				"Значение" контактной информации в табличной части КонтактнаяИнформация объекта
//				(см. описание подсистемы "Контактная информация" Библиотеки стандартных подсистем).
//			** Представление - Строка - представление телефона.
//			** Комментарий - Строка - произвольный комментарий.
//		* Руководитель - Структура, Неопределено - данные о руководителе.
//			** Должность - Строка - должность руководителя.
//			** Фамилия - Строка - фамилия руководителя.
//			** Имя - Строка - имя руководителя.
//			** Отчество - Строка - отчество руководителя.
//			** Представление - Строка - ФИО руководителя.
//			** ИНН - Строка - ИНН руководителя.
//			** ДатаЗаписи - Дата - дата записи о руководителе.
//		* ОписаниеОшибки - Строка - описание возникшей ошибки.
//			Для обработки ошибки на клиентской части необходимо использовать метод
//			РаботаСКонтрагентамиКлиент.ОбработатьОшибку.
//
Функция РеквизитыЮридическогоЛицаПоИНН(Знач ИНН) Экспорт
	
	ЗаписатьИнформациюВЖурналРегистрации(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Получение реквизитов юридического лица для ИНН %1'"),
			ИНН),
		"Контрагент",
		ДополнительноеСобытиеПолучениеДанных());
	
	РеквизитыОрганизации = НовыеРеквизитыЮридическогоЛица();
	РеквизитыОрганизации.ИНН = ИНН;
	
	ОписаниеОшибки = "";
	
	// Проверка наличия услуги.
	ИдентификаторУслуги = ИдентификаторУслугиЗаполнениеРеквизитовКонтрагентов();
	Если Не УслугаПодключена(ИдентификаторУслуги) Тогда
		ОписаниеОшибки = "УслугаНеПодключена";
	КонецЕсли;

	ПараметрыСервиса = ПараметрыСервисаЮридическиеЛица();
	ИмяМетода        = "findCorporationByInn";
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		ОбъектXDTO = Неопределено;
		Прокси = ПроксиСервиса(
			ПараметрыСервиса.URL,
			ПараметрыСервиса.URIПространстваИмен,
			ПараметрыСервиса.Имя,
			ПараметрыСервиса.ИмяТочкиПодключения,
			ОписаниеОшибки);
	КонецЕсли;
	
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		ЗаполнитьТикетАутентификации(Прокси, ПараметрыСервиса.URL, ИмяМетода, ОписаниеОшибки);
	КонецЕсли;
	
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		
		ВходныеПараметры = Прокси.ФабрикаXDTO.Создать(
			Прокси.ФабрикаXDTO.Тип(ПараметрыСервиса.URIПространстваИмен, "findCorporationByInn"));
		ВходныеПараметры.inn = ИНН;
		
		ВходныеПараметры.additionalParameters =
			ДополнительныеПараметрыВызоваОперацииСервиса(
				Прокси.ФабрикаXDTO,
				"http://company1c.com/orgregister/base");
		
		Попытка
			ОбъектXDTO = Прокси.FindCorporationByInn(ВходныеПараметры);
			Если НЕ ЗначениеЗаполнено(ОбъектXDTO.ИНН) Тогда 
				ОбъектXDTO = Неопределено;
			КонецЕсли;	
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки     = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='ИНН %1:'"), ИНН)
				+ Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
		
	КонецЕсли;
	
	ОбработатьОшибкуСервиса(
		ОбъектXDTO,
		ОписаниеОшибки,
		"Контрагент",
		ИмяМетода,
		ИдентификаторУслуги,
		РеквизитыОрганизации);
	
	Если ЗначениеЗаполнено(РеквизитыОрганизации.ОписаниеОшибки) Тогда
		Возврат РеквизитыОрганизации;
	КонецЕсли;
	
	ЗаполнитьНаименованияЮридическогоЛица(ОбъектXDTO, РеквизитыОрганизации);
	
	ЗаписатьИнформациюВЖурналРегистрации(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Успешно завершено получение реквизитов юридического лица для ИНН %1'"),
			ИНН),
		"Контрагент",
		ДополнительноеСобытиеПолучениеДанных());
	
	Возврат РеквизитыОрганизации;
	
КонецФункции

#КонецОбласти

#Область Банки

// Возвращает классификатор банков.
// 
// Возвращаемое значение:
//  XML - Классификатор.
//
Функция РеквизитыКлассификаторБанков() Экспорт
	
	ЗаписатьИнформациюВЖурналРегистрации(НСтр("ru = 'Получение классификатора банков'"), 
		"КлассификаторБанков",
		ДополнительноеСобытиеПолучениеДанных());
		
	Реквизиты = НовыеРеквизитыКлассификатор();
	ОписаниеОшибки = "";
	
	// Проверка наличия услуги.
	ИдентификаторУслуги = ИдентификаторУслугиКлассификаторБанков();
	Если Не УслугаПодключена(ИдентификаторУслуги) Тогда
		ОписаниеОшибки = "УслугаНеПодключена";
	КонецЕсли;

	ПараметрыСервиса = ПараметрыСервисаКлассификаторБанков();
	ИмяМетода        = "getСlassifier";
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		ОбъектXDTO = Неопределено;
		Прокси = ПроксиСервиса(
			ПараметрыСервиса.URL,
			ПараметрыСервиса.URIПространстваИмен,
			ПараметрыСервиса.Имя,
			ПараметрыСервиса.ИмяТочкиПодключения,
			ОписаниеОшибки);
	КонецЕсли;
	
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		ЗаполнитьТикетАутентификации(Прокси, ПараметрыСервиса.URL, ИмяМетода, ОписаниеОшибки);
	КонецЕсли;
	
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		
		ВходныеПараметры = Прокси.ФабрикаXDTO.Создать(
			Прокси.ФабрикаXDTO.Тип(ПараметрыСервиса.URIПространстваИмен, "getСlassifier"));
		
		ВходныеПараметры.additionalParameters =
			ДополнительныеПараметрыВызоваОперацииСервиса(
				Прокси.ФабрикаXDTO,
				"http://company1c.com/orgregister/base");
		
		Попытка
			ОбъектXDTO = Прокси.getСlassifier(ВходныеПараметры);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки     = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
		
	КонецЕсли;
	
	ОбработатьОшибкуСервиса(
		ОбъектXDTO,
		ОписаниеОшибки,
		"КлассификаторБанков",
		ИмяМетода,
		ИдентификаторУслуги,
		Реквизиты);
	
	Если ЗначениеЗаполнено(Реквизиты.ОписаниеОшибки) Тогда
		Возврат Реквизиты;
	КонецЕсли;
	
	Реквизиты.КлассификаторXML = ОбъектXDTO.КлассификаторXML;
	
	ЗаписатьИнформациюВЖурналРегистрации(НСтр("ru = 'Успешно завершено получение классификатора банков'"),
		"КлассификаторБанков",
		ДополнительноеСобытиеПолучениеДанных());
	
	Возврат Реквизиты;
	
КонецФункции

#КонецОбласти

#Область ПрочиеКлассификаторы

// Возвращает классификатор.
//
// Параметры:
//  ИмяСервиса	 - Строка	 - Имя, как оно задано в сервисе
// 
// Возвращаемое значение:
//  XML - Классификатор.
//
Функция РеквизитыКлассификатор(ИмяСервиса) Экспорт
	
	ЗаписатьИнформациюВЖурналРегистрации(НСтр("ru = 'Получение классификатора'"), 
		"Классификатор",
		ДополнительноеСобытиеПолучениеДанных());
		
	Реквизиты = НовыеРеквизитыКлассификатор();
	ОписаниеОшибки = "";
	
	// Проверка наличия услуги.
	ИдентификаторУслуги = ИдентификаторУслугиКлассификатор();
	Если Не УслугаПодключена(ИдентификаторУслуги) Тогда
		ОписаниеОшибки = "УслугаНеПодключена";
	КонецЕсли;

	Если ИмяСервиса = "PaymentCodesWsGetService" Тогда 
		ПараметрыСервиса = ПараметрыСервисаКлассификаторКодыПлатежей();
	ИначеЕсли ИмяСервиса = "ClassifierGKEDWsGetService" Тогда 
		ПараметрыСервиса = ПараметрыСервисаКлассификаторГКЭД();
	КонецЕсли;
	
	ИмяМетода        = "getСlassifier";
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		ОбъектXDTO = Неопределено;
		Прокси = ПроксиСервиса(
			ПараметрыСервиса.URL,
			ПараметрыСервиса.URIПространстваИмен,
			ПараметрыСервиса.Имя,
			ПараметрыСервиса.ИмяТочкиПодключения,
			ОписаниеОшибки);
	КонецЕсли;
	
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		ЗаполнитьТикетАутентификации(Прокси, ПараметрыСервиса.URL, ИмяМетода, ОписаниеОшибки);
	КонецЕсли;
	
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		
		ВходныеПараметры = Прокси.ФабрикаXDTO.Создать(
			Прокси.ФабрикаXDTO.Тип(ПараметрыСервиса.URIПространстваИмен, "getСlassifier"));
		
		ВходныеПараметры.additionalParameters =
			ДополнительныеПараметрыВызоваОперацииСервиса(
				Прокси.ФабрикаXDTO,
				"http://company1c.com/orgregister/base");
		
		Попытка
			ОбъектXDTO = Прокси.getСlassifier(ВходныеПараметры);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки     = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
		
	КонецЕсли;
	
	ОбработатьОшибкуСервиса(
		ОбъектXDTO,
		ОписаниеОшибки,
		"Классификатор",
		ИмяМетода,
		ИдентификаторУслуги,
		Реквизиты);
	
	Если ЗначениеЗаполнено(Реквизиты.ОписаниеОшибки) Тогда
		Возврат Реквизиты;
	КонецЕсли;
	
	Реквизиты.КлассификаторXML = ОбъектXDTO.КлассификаторXML;
	
	ЗаписатьИнформациюВЖурналРегистрации(НСтр("ru = 'Успешно завершено получение классификатора'"),
		"Классификатор",
		ДополнительноеСобытиеПолучениеДанных());
	
	Возврат Реквизиты;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбщегоНазначения

Функция УслугаПодключена(ИдентификаторУслуги)
	
	Возврат ИнтернетПоддержкаПользователей.УслугаПодключена(ИдентификаторУслуги);
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(
	Сообщение,
	ИдентификаторСервиса = Неопределено,
	ДополнительноеСобытие = Неопределено) Экспорт
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(ИдентификаторСервиса)
			+ ?(ДополнительноеСобытие = Неопределено, "", "." + ДополнительноеСобытие),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		Сообщение);
	
КонецПроцедуры

Процедура ЗаписатьИнформациюВЖурналРегистрации(
	Сообщение,
	ИдентификаторСервиса,
	ДополнительноеСобытие = Неопределено)
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(ИдентификаторСервиса)
			+ ?(ДополнительноеСобытие = Неопределено, "", "." + ДополнительноеСобытие),
		УровеньЖурналаРегистрации.Информация,
		,
		,
		Сообщение);
	
КонецПроцедуры

Функция ИмяСобытияЖурналаРегистрации(ИдентификаторСервиса)
	
	Если ИдентификаторСервиса = "Контрагент" Тогда
		Возврат НСтр("ru = 'Сервис данных единых гос_реестров'", ОбщегоНазначения.КодОсновногоЯзыка());
	ИначеЕсли ИдентификаторСервиса = "ГосОрганы" Тогда
		Возврат НСтр("ru = 'Сервис данных гос_органов'", ОбщегоНазначения.КодОсновногоЯзыка());
	ИначеЕсли ИдентификаторСервиса = "ПроверкаКонтрагентов" Тогда
		Возврат НСтр("ru = 'Проверка контрагентов'", ОбщегоНазначения.КодОсновногоЯзыка());
	Иначе
		Возврат НСтр("ru = 'Работа с контрагентами'", ОбщегоНазначения.КодОсновногоЯзыка());
	КонецЕсли;
	
КонецФункции

Функция ИдентификаторСервиса()
	
	Возврат "1C-Counteragent";
	
КонецФункции

#КонецОбласти

#Область Тарификация

Функция ИдентификаторУслугиЗаполнениеРеквизитовКонтрагентов()
	
	Возврат "1c-counteragent-autocomplete-contractor-details";
	
КонецФункции

Функция ИдентификаторУслугиКлассификаторБанков()
	
	Возврат "1c-classifier-get-banks";
	
КонецФункции

Функция ИдентификаторУслугиКлассификатор()
	
	Возврат "1c-classifier-get-etc";
	
КонецФункции

#КонецОбласти

#Область СервисыЗаполненияРеквизитов

#Область ОбщегоНазначения

Функция ПроксиСервиса(URLМестоположенияWSDL, URIПространстваИмен, ИмяСервиса, ИмяТочкиПодключения, ОписаниеОшибки)
	
	Прокси = Неопределено;
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		// Создание WSПрокси с аутентификацией по тикету аутентификации.
		ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
		ПараметрыПодключения.АдресWSDL           = URLМестоположенияWSDL;
		ПараметрыПодключения.URIПространстваИмен = URIПространстваИмен;
		ПараметрыПодключения.ИмяСервиса          = ИмяСервиса;
		//ПараметрыПодключения.ИмяТочкиПодключения = ИмяТочкиПодключения;
		ПараметрыПодключения.Таймаут             = 60;
		
		ОшибкаАутентификации = Ложь;
		
		// Попытка создания объекта без аутентификации (по данным Кэш).
		Попытка
			Прокси = ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
		Исключение
			ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
		Если Не ПустаяСтрока(ОписаниеОшибки) Тогда
			ОписаниеОшибкиВРег = ВРег(ОписаниеОшибки);
			ОшибкаАутентификации = (СтрНайти(ОписаниеОшибкиВРег, """STATUS"":401") > 0
				Или СтрНайти(ОписаниеОшибкиВРег, "SERVER-9:") > 0);
		КонецЕсли;
		
		Если ОшибкаАутентификации Тогда
			
			// Нет описания WSDL в кэше программных интерфейсов.
			// Получить новое описание с использованием тикета, новое описание
			// будет сохранено в кэше программных интерфейсов.
			ОписаниеОшибки = "";
			УстановитьПривилегированныйРежим(Истина);
			
			// Работа в модели сервиса.
			МодульИнтернетПоддержкаПользователейВМоделиСервиса =
				ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователейВМоделиСервиса");
			РезультатПолученияТикета = МодульИнтернетПоддержкаПользователейВМоделиСервиса.ТикетАутентификацииНаПорталеПоддержки(
				URLМестоположенияWSDL);
			
			УстановитьПривилегированныйРежим(Ложь);
			
			Если Не ПустаяСтрока(РезультатПолученияТикета.КодОшибки) Тогда
				ЗаписатьИнформациюВЖурналРегистрации(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не удалось получить тикет аутентификации для создания описания сервиса %1.
							|Код ошибки: %2.
							|Для аутентификации использован логин ""fresh"".'"),
						URLМестоположенияWSDL,
						РезультатПолученияТикета.КодОшибки),
					"РаботаСКонтрагентами");
				ПараметрыПодключения.ИмяПользователя = "fresh";
				ПараметрыПодключения.Пароль          = "fresh";
			Иначе
				ПараметрыПодключения.ИмяПользователя = "AUTH_TOKEN";
				ПараметрыПодключения.Пароль          = РезультатПолученияТикета.Тикет;
			КонецЕсли;
			
			Попытка
				Прокси = ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
			Исключение
				ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			КонецПопытки;
			
		КонецЕсли;
		
	Иначе
		// Создание WSПрокси в обычном режиме с аутентификацией по логину и паролю.
		УстановитьПривилегированныйРежим(Истина);
		ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		УстановитьПривилегированныйРежим(Ложь);
		Если ДанныеАутентификации = Неопределено Тогда
			ОписаниеОшибки = "НеУказаныПараметрыАутентификации";
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
		ПараметрыПодключения.АдресWSDL           = URLМестоположенияWSDL;
		ПараметрыПодключения.URIПространстваИмен = URIПространстваИмен;
		ПараметрыПодключения.ИмяСервиса          = ИмяСервиса;
		//ПараметрыПодключения.ИмяТочкиПодключения = ИмяТочкиПодключения;
		//ПараметрыПодключения.ИмяПользователя     = ДанныеАутентификации.Логин;
		//ПараметрыПодключения.Пароль              = ДанныеАутентификации.Пароль;
		ПараметрыПодключения.Таймаут             = 60;
		
		Попытка
			Прокси = ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
		Исключение
			ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

Процедура ЗаполнитьТикетАутентификации(ПроксиСервиса, АдресСервиса, ИмяМетода, ОписаниеОшибки)
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	// Получение тикета.
	УстановитьПривилегированныйРежим(Истина);
	
	// Работа в модели сервиса.
	МодульИнтернетПоддержкаПользователейВМоделиСервиса =
		ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователейВМоделиСервиса");
	РезультатПолученияТикета = МодульИнтернетПоддержкаПользователейВМоделиСервиса.ТикетАутентификацииНаПорталеПоддержки(
		АдресСервиса + "#" + ИмяМетода);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не ПустаяСтрока(РезультатПолученияТикета.КодОшибки) Тогда
		ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось получить тикет аутентификации для вызова операции %1 сервиса %2.
					|Код ошибки: %3.
					|Для аутентификации использован логин ""fresh"".'"),
				ИмяМетода,
				АдресСервиса,
				РезультатПолученияТикета.КодОшибки),
			"РаботаСКонтрагентами");
		ПроксиСервиса.Пользователь = "fresh";
		ПроксиСервиса.Пароль       = "fresh";
	Иначе
		ПроксиСервиса.Пользователь = "AUTH_TOKEN";
		ПроксиСервиса.Пароль       = РезультатПолученияТикета.Тикет;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьОшибкуСервиса(ОбъектXDTO, ОписаниеОшибки, Сервис, ИмяМетода, ИдентификаторУслуги, Результат)
	
	Если ОбъектXDTO <> Неопределено И Не ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	КодОсновногоЯзыка  = ОбщегоНазначения.КодОсновногоЯзыка(); // Для записи события в журнал регистрации.
	ОписаниеОшибкиВРег = ВРег(ОписаниеОшибки);
	
	Если ОписаниеОшибкиВРег = ВРег("НеУказаныПараметрыАутентификации")
		Или ОписаниеОшибкиВРег = ВРег("НеУказанПароль") Тогда
		
		Результат.ОписаниеОшибки = "НеУказаныПараметрыАутентификации";
		ЗаписатьИнформациюВЖурналРегистрации(
			НСтр("ru = 'Интернет-поддержка пользователей не подключена.'"),
			Сервис,
			НСтр("ru='Аутентификация'", КодОсновногоЯзыка));
		
	ИначеЕсли СтрНайти(ОписаниеОшибкиВРег, """STATUS"":401") > 0
		Или СтрНайти(ОписаниеОшибкиВРег, "SERVER-9:") > 0 Тогда
		
		Если ОбщегоНазначения.РазделениеВключено() Тогда
			Результат.ОписаниеОшибки = НСтр("ru = 'Ошибка аутентификации в сервисе. Обратитесь к администратору.'");
			ЗаписатьОшибкуВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка аутентификации в сервисе.
						|%1'"),
						ОписаниеОшибки),
				Сервис,
				НСтр("ru='Аутентификация'", КодОсновногоЯзыка));
		Иначе
			Результат.ОписаниеОшибки = "НеУказаныПараметрыАутентификации";
			ЗаписатьИнформациюВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Интернет-поддержка пользователей не подключена.
						|%1'"),
						ОписаниеОшибки),
				Сервис,
				НСтр("ru='Аутентификация'", КодОсновногоЯзыка));
		КонецЕсли;
		
	ИначеЕсли ОписаниеОшибкиВРег = ВРег("УслугаНеПодключена") Тогда
		
		Результат.ОписаниеОшибки = "Сервис1СКонтрагентНеПодключен";
		ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Услуга с идентификатором ""%1"" не подключена.'"),
				ИдентификаторУслуги),
			Сервис,
			НСтр("ru='Доступ'", КодОсновногоЯзыка));
		
	ИначеЕсли СтрНайти(ОписаниеОшибкиВРег, "SERVER-11:") > 0 
		Или СтрНайти(ОписаниеОшибкиВРег, "SERVER-12:") > 0 Тогда
		
		Результат.ОписаниеОшибки = "Сервис1СКонтрагентНеПодключен";
		ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сервис 1С:Контрагент не подключен.
					|%1'"),
					ОписаниеОшибки),
			Сервис,
			НСтр("ru='Доступ'", КодОсновногоЯзыка));
		
	ИначеЕсли СтрНайти(ОписаниеОшибкиВРег, "SERVER-1:") > 0 Тогда
		
		Если ИмяМетода = "findCorporationByInn"
			ИЛИ ИмяМетода = "findCorpTrustability" Тогда
			Результат.ОписаниеОшибки = НСтр("ru='Не указан ИНН юридического лица.'");
		ИначеЕсли ИмяМетода = "findCorporationsByName" Тогда
			Результат.ОписаниеОшибки = НСтр("ru='Не указано наименование юридического лица.'");
		Иначе
			Результат.ОписаниеОшибки = ОписаниеОшибки;
		КонецЕсли;
		
		ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1
					|%2'"),
					Результат.ОписаниеОшибки,
					ОписаниеОшибки),
			Сервис,
			НСтр("ru='Получение данных'", КодОсновногоЯзыка));
		
	ИначеЕсли СтрНайти(ОписаниеОшибкиВРег, "SERVER-2:") > 0 Тогда
		
		Если ИмяМетода = "findCorporationByInn" Тогда
			Результат.ОписаниеОшибки = НСтр("ru='ИНН юридического лица должен состоять из 14 цифр.'");
		Иначе
			Результат.ОписаниеОшибки = ОписаниеОшибки;
		КонецЕсли;
		
		ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1
					|%2'"),
					Результат.ОписаниеОшибки,
					ОписаниеОшибки),
			Сервис,
			НСтр("ru='Получение данных'", КодОсновногоЯзыка));
		
	ИначеЕсли СтрНайти(ОписаниеОшибкиВРег, "SERVER-3:") > 0 Тогда
		
		Если ИмяМетода = "findCorporationByInn" Тогда
			Результат.ОписаниеОшибки = НСтр("ru='ИНН юридического лица должен содержать только цифры.'");
		Иначе
			Результат.ОписаниеОшибки = ОписаниеОшибки;
		КонецЕсли;
		
		ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1
					|%2'"),
					Результат.ОписаниеОшибки,
					ОписаниеОшибки),
			Сервис,
			НСтр("ru='Получение данных'", КодОсновногоЯзыка));
		
	ИначеЕсли СтрНайти(ОписаниеОшибкиВРег, "SERVER-4:") > 0 Тогда
		
		Результат.ОписаниеОшибки = НСтр("ru = 'Превышено количество попыток. Повторите попытку позже.'");
		ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Превышено количество попыток. Повторите попытку позже.
					|%1'"),
					ОписаниеОшибки),
			Сервис,
			НСтр("ru='Вызов операций'", КодОсновногоЯзыка));
		
	ИначеЕсли СтрНайти(ОписаниеОшибки, "SERVER-7:") > 0 Тогда
		
		Результат.ОписаниеОшибки = НСтр("ru='Превышен лимит количества вызовов сервиса за один день'");
		ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1
					|%2'"),
					Результат.ОписаниеОшибки,
					ОписаниеОшибки),
			Сервис,
			НСтр("ru='Доступ'", КодОсновногоЯзыка));
		
	ИначеЕсли СтрНайти(ОписаниеОшибки, "SERVER-8:") > 0 Тогда
		
		Результат.ОписаниеОшибки = НСтр("ru='Отсутствует действующий договор ИТС'");
		ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1
					|%2'"),
					Результат.ОписаниеОшибки,
					ОписаниеОшибки),
			Сервис,
			НСтр("ru='Доступ'", КодОсновногоЯзыка));
		
	ИначеЕсли Не ЗначениеЗаполнено(ОписаниеОшибки) И ОбъектXDTO = Неопределено Тогда
		
		Если ИмяМетода = "findCorporationByInn"
			ИЛИ ИмяМетода = "findEntrepreneurByInn" Тогда
			Результат.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось найти данные для заполнения реквизитов по ИНН %1.'"),
				Результат.ИНН);
		ИначеЕсли ИмяМетода = "findCorporationsByName" Тогда
			Результат.ОписаниеОшибки = НСтр("ru='Не удалось выполнить поиск по наименованию.'");
		ИначеЕсли ИмяМетода = "findInspectionsByInnList" Тогда
			Результат.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось найти данные о проверках по ИНН %1.'"),
				Результат.ИНН);
		ИначеЕсли ИмяМетода = "findCorpTrustability" Тогда
			Результат.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось найти данные о юридическом лице с ИНН %1.'"),
				Результат.ИНН);
		ИначеЕсли ИмяМетода = "findEntrTrustabilityByInn" Тогда
			Результат.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось найти данные о предпринимателе с ИНН %1.'"),
				Результат.ИНН);
		ИначеЕсли ИмяМетода = "findPfrByCode"
			Или ИмяМетода = "findFssByCode"
			Или ИмяМетода = "findIfnsByCode" Тогда
			Результат.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Данные о государственном органе с кодом %1 не найдены.'"),
				Результат.Код);
		КонецЕсли;
		
		ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1
					|Получен пустой ответ сервиса.'"),
				Результат.ОписаниеОшибки,
				ОписаниеОшибки),
			Сервис,
			НСтр("ru='Получение данных'", КодОсновногоЯзыка));
		
	Иначе
		
		Результат.ОписаниеОшибки = НСтр("ru='Ошибка при работе с сервисом (подробнее см. Журнал регистрации)'");
		ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при работе с сервисом.
					|%1.'"),
				ОписаниеОшибки),
			Сервис,
			НСтр("ru='Ошибка'", КодОсновногоЯзыка));
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДополнительноеСобытиеПолучениеДанных()
	
	Возврат НСтр("ru='Получение данных'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция ДополнительныеПараметрыВызоваОперацииСервиса(ФабрикаXDTOСервиса, URIПространстваИмен)
	
	ИмяКонфигурации = ИнтернетПоддержкаПользователей.ИмяКонфигурации();
	ВерсияКонфигурации = ИнтернетПоддержкаПользователей.ВерсияКонфигурации();
	ТипДополнительныеПараметрыXDTO = ФабрикаXDTOСервиса.Тип(URIПространстваИмен, "AdditionalParameters");
	ТипДополнительныйПараметрXDTO = ФабрикаXDTOСервиса.Тип(URIПространстваИмен, "AdditionalParameter");
	
	Результат = ФабрикаXDTOСервиса.Создать(ТипДополнительныеПараметрыXDTO);
	
	ДополнительныйПараметрXDTO = ФабрикаXDTOСервиса.Создать(ТипДополнительныйПараметрXDTO);
	ДополнительныйПараметрXDTO.name  = "ConfigurationName";
	ДополнительныйПараметрXDTO.value = ИмяКонфигурации;
	Результат.Parameter.Добавить(ДополнительныйПараметрXDTO);
	
	ДополнительныйПараметрXDTO = ФабрикаXDTOСервиса.Создать(ТипДополнительныйПараметрXDTO);
	ДополнительныйПараметрXDTO.name  = "ConfigurationVersion";
	ДополнительныйПараметрXDTO.value = ВерсияКонфигурации;
	Результат.Parameter.Добавить(ДополнительныйПараметрXDTO);
	
	ДополнительныйПараметрXDTO = ФабрикаXDTOСервиса.Создать(ТипДополнительныйПараметрXDTO);
	ДополнительныйПараметрXDTO.name  = "SupportsCustomAddressElements";
	ДополнительныйПараметрXDTO.value = "true";
	Результат.Parameter.Добавить(ДополнительныйПараметрXDTO);
	
	ДополнительныйПараметрXDTO = ФабрикаXDTOСервиса.Создать(ТипДополнительныйПараметрXDTO);
	ДополнительныйПараметрXDTO.name  = "SupportsAddressFormatV2";
	ДополнительныйПараметрXDTO.value = "true";
	Результат.Parameter.Добавить(ДополнительныйПараметрXDTO);
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	УстановитьПривилегированныйРежим(Ложь);
	
	ДополнительныйПараметрXDTO = ФабрикаXDTOСервиса.Создать(ТипДополнительныйПараметрXDTO);
	ДополнительныйПараметрXDTO.name  = "login";
	ДополнительныйПараметрXDTO.value = ДанныеАутентификации.Логин;
	Результат.Parameter.Добавить(ДополнительныйПараметрXDTO);
	
	ДополнительныйПараметрXDTO = ФабрикаXDTOСервиса.Создать(ТипДополнительныйПараметрXDTO);
	ДополнительныйПараметрXDTO.name  = "password";
	ДополнительныйПараметрXDTO.value = ДанныеАутентификации.Пароль;
	Результат.Parameter.Добавить(ДополнительныйПараметрXDTO);
	
	ОрганизацияПоУмолчанию = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
	ДополнительныйПараметрXDTO = ФабрикаXDTOСервиса.Создать(ТипДополнительныйПараметрXDTO);
	ДополнительныйПараметрXDTO.name  = "OrganizationName";
	ДополнительныйПараметрXDTO.value = ОрганизацияПоУмолчанию.НаименованиеПолное;
	Результат.Parameter.Добавить(ДополнительныйПараметрXDTO);
	
	ДополнительныйПараметрXDTO = ФабрикаXDTOСервиса.Создать(ТипДополнительныйПараметрXDTO);
	ДополнительныйПараметрXDTO.name  = "OrganizationINN";
	ДополнительныйПараметрXDTO.value = ОрганизацияПоУмолчанию.ИНН;
	Результат.Parameter.Добавить(ДополнительныйПараметрXDTO);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОписанияРеквизитов

Функция БазовыйURLСервиса()
	
	Возврат "http://service.1ckato.kg:81/ak";
	
КонецФункции

Функция ПараметрыСервисаЮридическиеЛица()
	
	Результат = Новый Структура;
	Результат.Вставить("URL", БазовыйURLСервиса() + "/ws/CorpWsImplService?wsdl");
	Результат.Вставить("Имя"                , "CorpWsImplService");
	Результат.Вставить("URIПространстваИмен", "http://ws.corporation.company1c.com");
	Результат.Вставить("ИмяТочкиПодключения", "CorpWsImplPort");
	
	Возврат Результат;
	
КонецФункции

Функция ПараметрыСервисаКлассификаторБанков()
	
	Результат = Новый Структура;
	Результат.Вставить("URL", БазовыйURLСервиса() + "/ws/BanksWsGetService?wsdl");
	Результат.Вставить("Имя"                , "BanksWsGetService");
	Результат.Вставить("URIПространстваИмен", "http://ws.banks.company1c.com");
	Результат.Вставить("ИмяТочкиПодключения", "BanksWsGetPort");
	
	Возврат Результат;
	
КонецФункции

Функция ПараметрыСервисаКлассификаторКодыПлатежей()
	
	Результат = Новый Структура;
	Результат.Вставить("URL", БазовыйURLСервиса() + "/ws/PaymentCodesWsGetService?wsdl");
	Результат.Вставить("Имя"                , "PaymentCodesWsGetService");
	Результат.Вставить("URIПространстваИмен", "http://ws.paymentcodes.company1c.com");
	Результат.Вставить("ИмяТочкиПодключения", "PaymentCodesWsGetPort");
	
	Возврат Результат;
	
КонецФункции

Функция ПараметрыСервисаКлассификаторГКЭД()
	
	Результат = Новый Структура;
	Результат.Вставить("URL", БазовыйURLСервиса() + "/ws/ClassifierGKEDWsGetService?wsdl");
	Результат.Вставить("Имя"                , "ClassifierGKEDWsGetService");
	Результат.Вставить("URIПространстваИмен", "http://ws.classifierGKED.company1c.com");
	Результат.Вставить("ИмяТочкиПодключения", "ClassifierGKEDWsGetPort");
	
	Возврат Результат;
	
КонецФункции

Функция НовыеРеквизитыЮридическогоЛица()

	РеквизитыОрганизации = Новый Структура;
	
	// Заполняется на основе данных ЕГРЮЛ.
	РеквизитыОрганизации.Вставить("ИНН");
	РеквизитыОрганизации.Вставить("Наименование");
	РеквизитыОрганизации.Вставить("НаименованиеПолное");
	РеквизитыОрганизации.Вставить("НаименованиеСокращенное");
	РеквизитыОрганизации.Вставить("Статус", Неопределено);
	РеквизитыОрганизации.Вставить("КодПоОКПО");
	
	// Следующие свойства могут содержать Неопределено в случае отсутствия в сервисе данных.
	РеквизитыОрганизации.Вставить("КодПравовойФормы");
	РеквизитыОрганизации.Вставить("ЮридическийАдрес");
	РеквизитыОрганизации.Вставить("Телефон");
	РеквизитыОрганизации.Вставить("Руководитель");
	
	// Служебный реквизит
	РеквизитыОрганизации.Вставить("ОписаниеОшибки");
	
	Возврат РеквизитыОрганизации;

КонецФункции

Функция НовыеРеквизитыКлассификатор()

	Реквизиты = Новый Структура;
	Реквизиты.Вставить("КлассификаторXML");

	// Служебный реквизит
	Реквизиты.Вставить("ОписаниеОшибки");
	
	Возврат Реквизиты;

КонецФункции


#КонецОбласти

#Область ЗаполнениеРеквизитов

Процедура ЗаполнитьНаименованияЮридическогоЛица(ОбъектXDTO, Реквизиты)
	
	ЗаполнитьЗначенияСвойств(Реквизиты, ОбъектXDTO); 
	Реквизиты.ЮридическийАдрес = ОбъектXDTO.Адрес;
	
	Попытка
		Реквизиты.КодПравовойФормы = Перечисления.КодыПравовойФормы[Реквизиты.КодПравовойФормы];
	Исключение
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти
