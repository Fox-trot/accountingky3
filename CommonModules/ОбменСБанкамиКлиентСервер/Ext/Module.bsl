﻿////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиКлиентСервер: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует текст гиперссылки для размещения в форме элемента справочника БанковскиеСчетаОрганизации.
//
// Параметры:
//  Организация  - СправочникСсылка.Организации - организация, указанная в счете.
//  Банк  - СправочникСсылка.КлассификаторБанков - банк, указанный в счете.
//
// Возвращаемое значение:
//   Строка - текст для гиперссылки.
//
Функция ЗаголовокНастройкиОбменаСБанком(Знач Организация, Знач Банк) Экспорт
	
	ТекущаяНастройка = ОбменСБанкамиСлужебныйВызовСервера.НастройкаОбмена(Организация, Банк, Истина, Ложь);
	
	Если НЕ ЗначениеЗаполнено(ТекущаяНастройка) Тогда
		Возврат(НСтр("ru = 'Подключить сервис 1С:ДиректБанк'"));
	Иначе
		РеквизитыНастройкиОбмена = Новый Структура("Недействительна, ПометкаУдаления");
		ОбменСБанкамиСлужебныйВызовСервера.ПолучитьЗначенияРеквизитовНастройкиОбмена(
			ТекущаяНастройка, РеквизитыНастройкиОбмена);
		Если НЕ РеквизитыНастройкиОбмена.Недействительна И НЕ РеквизитыНастройкиОбмена.ПометкаУдаления Тогда
			Шаблон = НСтр("ru = 'Сервис 1С:ДиректБанк подключен'");
		Иначе
			Шаблон = НСтр("ru = 'Не подключен сервис 1С:ДиректБанк'");
		КонецЕсли;
		Возврат Шаблон;
	КонецЕсли
	
КонецФункции

// Получает текстовое представление версии электронного документа.
//
// Параметры:
//  СсылкаНаВладельца - СправочникСсылка.НастройкиОбменСБанками, ДокументСсылка.СообщениеОбменСБанками - Ссылка на объект ИБ, состояние версии электронного документа которого необходимо получить
//  Форма - ФормаКлиентскогоПриложения, Форма - форма в которой необходимо изменить текст состояния ЭДО.
//
// Возвращаемое значение:
//  Строка - текстовое представление версии электронного документа.
//
Функция ПолучитьТекстСостоянияЭД(СсылкаНаВладельца, Форма = Неопределено) Экспорт
	
	Гиперссылка = Ложь;
	ТекстСостоянияЭД = ОбменСБанкамиСлужебныйВызовСервера.ТекстСостоянияЭД(СсылкаНаВладельца, Гиперссылка);
	
	Если НЕ Форма = Неопределено Тогда
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("ТекстСостоянияЭДО", ТекстСостоянияЭД);
		СтруктураПараметров.Вставить("ВидОперации", "УстановкаГиперссылки");
		СтруктураПараметров.Вставить("ЗначениеПараметра", Гиперссылка);
		#Если  ТолстыйКлиентОбычноеПриложение Тогда
			ЭлектронноеВзаимодействиеПереопределяемый.ИзменитьСвойстваЭлементовФормы(Форма, СтруктураПараметров);
		#Иначе
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ИзменитьСвойстваЭлементовФормы(Форма, СтруктураПараметров);
		#КонецЕсли
	КонецЕсли;
	
	Возврат ТекстСостоянияЭД;
	
КонецФункции

// Управляет видимостью и содержанием контекстной рекламы 1С:ДиректБанк.
// 
// Параметры:
//  ГруппаРекламы - ГруппаФормы - группа элементов контекстной рекламы;
//  ДекорацияТекстРекламы - ДекорацияФормы - декорация, в заголовке которой отображается текст рекламы.
// 
Процедура ПоказатьРекламуДиректБанк(ГруппаРекламы, ДекорацияТекстРекламы) Экспорт
	
	КоличествоБанков = ОбменСБанкамиСлужебныйВызовСервера.КоличествоБанковДляПодключенияДиректБанк();
	
	Если КоличествоБанков = 0 Тогда
		ГруппаРекламы.Видимость = Ложь;
	Иначе
		Заголовок = СформироватьЗаголовокРекламыДиректБанк(КоличествоБанков);
		ДекорацияТекстРекламы.Заголовок = Заголовок;
		ГруппаРекламы.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текст гиперссылки для открытия переписки с банками
// 
// Возвращаемое значение:
//  Строка - текст гиперссылки
//  Неопределено - нет настройки обмена с письмами. Гиперссылку не нужно выводить.
//
Функция ТекстСсылкиПерепискаСБанками() Экспорт
	
	Если НЕ ОбменСБанкамиСлужебныйВызовСервера.ПравоЧтенияДанных() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекущееСостояниеПисемСБанками = ОбменСБанкамиСлужебныйВызовСервера.ТекущееСостояниеПисемСБанками();
	
	Если НЕ ТекущееСостояниеПисемСБанками.ЕстьНастройка Тогда
		Возврат Неопределено;
	ИначеЕсли ТекущееСостояниеПисемСБанками.КоличествоНепрочитанных = 0 Тогда
		Возврат НСтр("ru = 'Переписка с банками'");
	Иначе
		Шаблон = НСтр("ru = 'Переписка с банками (%1)'");
		Возврат СтрШаблон(Шаблон, ТекущееСостояниеПисемСБанками.КоличествоНепрочитанных);
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Подготавливает структуру для возврата данных обмена после получения новых документов из банка.
// 
// Возвращаемое значение:
//  Структура - содержит следующие поля:
//   * ДанныеЭП - Соответствие - содержит данные электронных подписей, которые необходимо проверить на клиенте.
//   * КоличествоПолученныхПакетов - Число - количество пакетов, которые были получены из банка.
//   * ПараметрОповещения - Соответствие - данные для оповещения прикладных решений.
//   * ЕстьОшибка - Булево - если вернулось значение Истина, то произошла ошибка.
//   * ТребуетсяПовторнаяАутентификация - Булево - если вернулось значение Истина, то сессия закончилась и требуется повторная аутентификация.
//   * МассивОповещений - Массив - оповещения, сформированные в переопределяемой части. Используется в зарплатном проекте.
//
Функция ПараметрыПолученияНовыхДокументовАсинхронныйОбмен() Экспорт
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ДанныеЭП", Новый Соответствие);
	СтруктураВозврата.Вставить("КоличествоПолученныхПакетов", 0);
	СтруктураВозврата.Вставить("ПараметрОповещения", Новый Соответствие);
	СтруктураВозврата.Вставить("ЕстьОшибка", Ложь);
	СтруктураВозврата.Вставить("ТребуетсяПовторнаяАутентификация", Ложь);
	СтруктураВозврата.Вставить("МассивОповещений", Новый Массив);
	
	Возврат СтруктураВозврата
	
КонецФункции

// Возвращает версию схемы XSD для асинхронного обмена с банком, которые гарантированно поддерживают все банки.
//
// Возвращаемое значение:
//    Строка - версия формата асинхронного обмена.
//
Функция БазоваяВерсияФорматаАсинхронногоОбмена() Экспорт
	
	Возврат "2.1.1";
	
КонецФункции

// Возвращает версию схемы XSD для асинхронного обмена с банком.
//
// Возвращаемое значение:
//    Строка - актуальная версия формата асинхронного обмена.
//
Функция АктуальнаяВерсияФорматаАсинхронногоОбмена() Экспорт
	
	Возврат "2.2.1";
	
КонецФункции

// Возвращает текущую версию формата для синхронного обмена
// 
// Возвращаемое значение:
//  Строка - версия формата
//
Функция ВерсияФорматаСинхронногоОбмена() Экспорт
	
	Возврат "1.08";
	
КонецФункции

// Возвращает версию схемы XSD для асинхронного обмена с банком, которые гарантированно поддерживают все банки.
//
// Возвращаемое значение:
//    Строка - версия формата асинхронного обмена.
//
Функция УстаревшаяВерсияФорматаАсинхронногоОбмена() Экспорт
	
	Возврат "2.03";
	
КонецФункции

// Проверяет заполнение обязательных реквизитов настроек обмена с банками
//
// Параметры:
//  Объект  - СправочникОбъект.НастройкиОбменСБанками - проверяемая настройка.
//
// Возвращаемое значение:
//   Булево   - Истина - заполнены все необходимые реквизиты.
//
Функция ЗаполненыРеквизитыНастройкиОбмена(Объект, ЭтоТест = Ложь) Экспорт
	
	Отказ = Ложь;
	
	Если Не ЭтоТест И Объект.Недействительна Тогда
		Возврат Истина;
	КонецЕсли;
		
	Если ЭтоТест И Объект.Недействительна Тогда
		ТекстСообщения = НСтр("ru = 'Для обмена по данной настройке необходимо снять флаг Недействительна'");
		СообщитьПользователю(ТекстСообщения, "Недействительна", "Объект");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения(
			"Поле", "Заполнение", НСтр("ru = 'Организация'"));
		СообщитьПользователю(ТекстСообщения, "Организация", "Объект", Отказ);
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(Объект.Банк) Тогда
		ТекстСообщения = ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения(
			"Поле", "Заполнение", НСтр("ru = 'Банк'"));
		СообщитьПользователю(ТекстСообщения, "Банк", "Объект", Отказ);
	КонецЕсли;
		
	Если (Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.СбербанкОнлайн")
			ИЛИ Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.АсинхронныйОбмен"))
		И (НЕ ЗначениеЗаполнено(Объект.ИдентификаторОрганизации)
			ИЛИ Объект.ИдентификаторОрганизации = "00000000-0000-0000-0000-000000000000") Тогда
		ТекстСообщения = ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения(
			"Поле", "Заполнение", НСтр("ru = 'Идентификатор организации'"));
		СообщитьПользователю(ТекстСообщения, "ИдентификаторОрганизации", "Объект", Отказ);
	КонецЕсли;
	
	Если (Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезДопОбработку")
			ИЛИ Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезВК"))
		И НЕ ЗначениеЗаполнено(Объект.ИмяВнешнегоМодуля) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не загружен внешний модуль'");
		СообщитьПользователю(ТекстСообщения, , "Объект", Отказ);
	КонецЕсли;
	
	Если Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.АльфаБанкОнлайн")
		ИЛИ Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.АсинхронныйОбмен") Тогда
		Если НЕ ЗначениеЗаполнено(Объект.АдресСервера) Тогда
			ТекстСообщения = ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения(
				"Поле", "Заполнение", НСтр("ru = 'Адрес сервера банка'"));
			СообщитьПользователю(ТекстСообщения, "АдресСервера", "Объект", Отказ);
		КонецЕсли;
		Если Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.АльфаБанкОнлайн") Тогда
			Если НЕ ЗначениеЗаполнено(Объект.РесурсИсходящихДокументов) Тогда
				ТекстСообщения = ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения(
					"Поле", "Заполнение", НСтр("ru = 'Ресурс для отправки'"));
				СообщитьПользователю(ТекстСообщения, "РесурсИсходящихДокументов", "Объект", Отказ);
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(Объект.РесурсВходящихДокументов) Тогда
				ТекстСообщения = ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения(
					"Поле", "Заполнение", НСтр("ru = 'Ресурс для получения'"));
				СообщитьПользователю(ТекстСообщения, "РесурсВходящихДокументов", "Объект", Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.СбербанкОнлайн")
		И ЗначениеЗаполнено(Объект.ИдентификаторОрганизации) Тогда
		Попытка
			Идентификатор = Новый УникальныйИдентификатор(Объект.ИдентификаторОрганизации);
		Исключение
			ТекстСообщения = ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения(
				"Поле", "Корректность", НСтр("ru = 'Идентификатор организации'"));
			СообщитьПользователю(ТекстСообщения, "ИдентификаторОрганизации", "Объект", Отказ);
		КонецПопытки
	КонецЕсли;
		
	Если (Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезДопОбработку")
			ИЛИ Объект.ИспользуетсяКриптография) И Объект.СертификатыПодписейОрганизации.Количество() = 0 Тогда
		ТекстСообщения = ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения(
			"Список", "Заполнение", , , НСтр("ru = 'Сертификаты ключа электронной подписи'"));
		СообщитьПользователю(ТекстСообщения, "СертификатыПодписейОрганизации", "Объект", Отказ);
	КонецЕсли;
	
	// Проверим заполненность маршрута подписания в исходящих документах
	Отбор = Новый Структура;
	Отбор.Вставить("МаршрутПодписания", ПредопределенноеЗначение("Справочник.МаршрутыПодписания.ПустаяСсылка"));
	Отбор.Вставить("ИспользоватьЭП", 	Истина);
	СтрокиСПустымиМаршрутами = Объект.ИсходящиеДокументы.НайтиСтроки(Отбор);
	Для Каждого СтрокаОшибки Из СтрокиСПустымиМаршрутами Цикл
		ТекстОшибки = ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения("Колонка", "Заполнение", "МаршрутПодписания", 
			СтрокаОшибки.НомерСтроки, НСтр("ru = 'Исходящие электронные документы'"));
		ИмяПоля = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"ИсходящиеДокументы[%1].МаршрутПодписания", СтрокаОшибки.НомерСтроки - 1);
		
		СообщитьПользователю(ТекстОшибки, ИмяПоля, "Объект", Отказ);
	КонецЦикла;
	
	Если Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.АсинхронныйОбмен")
		И Объект.ПоказыватьОкноПодтвержденияПлатежей И НЕ ЗначениеЗаполнено(Объект.АдресЛичногоКабинета) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо указать адрес личного кабинета банка
									|или отключить открытие формы подтверждения платежа'");
		СообщитьПользователю(ТекстСообщения, "АдресЛичногоКабинета", "Объект", Отказ);
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

// Проверяет корректность URL.
// 
// Параметры:
//  АдресСервера - Строка - URL сервера банка.
//
// Возвращаемое значение:
//  Булево - Истина, если адрес корректный, иначе Ложь.
//
Функция ПравильныйФорматАдреса(АдресСервера) Экспорт
	
	Если НРег(Лев(АдресСервера, 7)) = "http://"
			ИЛИ НРег(Лев(АдресСервера, 8)) = "https://" Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Формирует параметры получения выписки банка
// 
// Возвращаемое значение:
//  Структура - содержит параметры получения выписки. Все поля необязательны для заполнения.
//
Функция ПараметрыПолученияВыпискиБанка() Экспорт
	
	Возврат Новый Структура("ДатаНачала, ДатаОкончания, НомерСчета");
	
КонецФункции

// Возвращает данные для подтверждения платежа в личном кабинете банка.
// 
// Возвращаемое значение:
//  Структура - инициализированные параметры.
//
Функция СтруктураПодтвержденияПлатежа() Экспорт
	
	ПодтверждениеПлатежейВБанке = Новый Структура;
	ПодтверждениеПлатежейВБанке.Вставить("БанкиТребующиеПодтверждениеПлатежаВЛК", Новый Массив);
	ПодтверждениеПлатежейВБанке.Вставить("НастройкиОбмена", Новый Массив);
	Возврат ПодтверждениеПлатежейВБанке;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует заголовок контекстной рекламы 1С:ДиректБанк
//
// Параметры:
//  КоличествоБанков - Число, Неопределено - Количество банков, с которыми можно настроить обмен.
//
Функция СформироватьЗаголовокРекламыДиректБанк(КоличествоБанков)
	
	МассивСтрок = Новый Массив;
	
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = '1С:ДиректБанк'"), Новый Шрифт(,15,Истина)));
	МассивСтрок.Добавить(Символы.ПС);
	
	МассивСтрокГиперссылки = Новый Массив;
	МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Подробнее'"), Новый Шрифт(,,Истина)));
	МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(" ", Новый Шрифт(,12,Истина)));
	МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'о сервисе'"), Новый Шрифт(,,Истина)));
	
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
	    МассивСтрокГиперссылки,,,,"http://www.v8.1c.ru/edi/edi_app/bank/?utm_source=led&utm_campaign=2017&utm_medium=app"));
	МассивСтрок.Добавить(Символы.ПС);
	
	Если КоличествоБанков = Неопределено Тогда
		
		МассивСтрокГиперссылки = Новый Массив;
		МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Поддерживаемые'"), Новый Шрифт(,,Истина)));
		МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(" ", Новый Шрифт(,14,Истина)));
		МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'банки'"), Новый Шрифт(,,Истина)));
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
		    МассивСтрокГиперссылки,,,,"http://www.v8.1c.ru/edi/edi_app/bank/banks.htm?utm_source=led&utm_campaign=2017&utm_medium=app"));
		
	Иначе
		
		МассивСтрокГиперссылки = Новый Массив;
		МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Подключить банки'"), Новый Шрифт(,,Истина)));
		МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(" ", Новый Шрифт(,14,Истина)));
		МассивСтрокГиперссылки.Добавить(Новый ФорматированнаяСтрока(
			СтрШаблон("(%1)", КоличествоБанков), Новый Шрифт(,,Истина)));
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
		    МассивСтрокГиперссылки,,,,
			"ОткрытьПомощникСозданияНастройкиОбмена"));
		
	КонецЕсли;	
		
	Возврат Новый ФорматированнаяСтрока(МассивСтрок);
		
КонецФункции

#Область Сбербанк

// Выводит сообщение об ошибке
//
// Параметры:
//  ВидОперации - Строка - описание выполняемой операции
//  КодОшибки - Строка - код ошибки, который вернул банк
//  Ключ - Произвольный - объект привязки сообщения.
//
Процедура СообщитьОбОшибкеСбербанк(ВидОперации, КодОшибки, Ключ = Неопределено) Экспорт
	
	ТекущаяОшибка = ТекстОшибкиСбербанк(КодОшибки);
	
	Если ТекущаяОшибка = Неопределено Тогда
		ШаблонОшибки = НСтр("ru = 'При аутентификации произошла ошибка.
								|Код: %1'");
		ТекстОшибки = СтрШаблон(ШаблонОшибки, КодОшибки);
	Иначе
		ШаблонОшибки = НСтр("ru = 'При аутентификации произошла ошибка.
								|Код: %1
								|Описание: %2'");
		ТекстОшибки = СтрШаблон(ШаблонОшибки, ТекущаяОшибка.Код, ТекущаяОшибка.Описание);
	КонецЕсли;
	
	ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки, ТекстОшибки, "ОбменСБанками", Ключ);
	
КонецПроцедуры

// Формирует текст сообщения по его коду
//
// Параметры:
//  Тикет - Строка - код ошибки, полученный из банка.
// 
// Возвращаемое значение:
//  Строка - текст сообщения, который необходимо вывести пользователю.
//
Функция ТекстСообщенияСбербанк(Тикет) Экспорт
	
	Если Тикет = "00000000-0000-0000-0000-000000000000" Тогда
		ТекстСообщения = НСтр("ru = 'Сервер банка временно недоступен. Повторите попытку позже или обратитесь в свой банк.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000001" Тогда
		ТекстСообщения = НСтр("ru = 'Неверный формат идентификатора сессии.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000002" Тогда
		ТекстСообщения = НСтр("ru = 'Неверный идентификатор сессии.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000003" Тогда
		ТекстСообщения = НСтр("ru = 'При вызове метода SendRequestSRP отправлен пустой request.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000004" Тогда
		ТекстСообщения = НСтр("ru = 'Среди параметров метода SendRequestSRP нет request-ов.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000005" Тогда
		ТекстСообщения = НСтр("ru = 'Неверный логин пользователя.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000006" Тогда
		ТекстСообщения = НСтр("ru = 'В сообщении не найден orgId, либо значение не соответствует формату.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000007" Тогда
		ТекстСообщения = НСтр("ru = 'Неверный идентификатор организации.
									|Проверьте настройки обмена с сервисом 1С:ДиректБанк или обратитесь в свой банк.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000008" Тогда
		ТекстСообщения = НСтр("ru = 'Не найден ContractAccessCode в БД роутера.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000009" Тогда
		ТекстСообщения = НСтр("ru = 'Не верный формат org id.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000010" Тогда
		ТекстСообщения = НСтр("ru = 'Не найден сертификат.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000011" Тогда
		ТекстСообщения = НСтр("ru = 'Размер пакета превысил максимально допустимый.
									|Обратитесь в техническую поддержку.'");
	ИначеЕсли Тикет = "00000000-0000-0000-0000-000000000012" Тогда
		ТекстСообщения = НСтр("ru = 'Ошибка доступа к серверу.
									|Обратитесь в техническую поддержку.'");
	Иначе
		ТекстСообщения = НСтр("ru = 'Сервер банка вернул неизвестный код ошибки.
								|Повторите сеанс связи или обратитесь в свой банк.'");
	КонецЕсли;
		
	Возврат ТекстСообщения;
	
КонецФункции

// Возвращает информацию об ошибке по коду.
//
// Параметры:
//  КодОшибки - Строка - код ошибки, полученный от сервера банка.
//
// Возвращаемое значение:
//  Структура - информация об ошибке, содержит поля:
//   * Код - Строка - цифровой код ошибки
//   * Описание - Строка - подробное описание ошибки.
//
Функция ТекстОшибкиСбербанк(КодОшибки) Экспорт
	
	СписокКодовСбербанк = Новый Соответствие;
	Описание = НСтр("ru = 'Неверный логин/пароль или учетная запись заблокирована.'");
	СписокКодовСбербанк.Вставить("AQ==", Новый Структура("Код, Описание", "01", Описание));
	Описание = НСтр("ru = 'Необходимо сменить пароль.'");
	СписокКодовСбербанк.Вставить("Ag==", Новый Структура("Код, Описание", "02", Описание));
	Описание = НСтр("ru = 'Срок действия сертификата истек.'");
	СписокКодовСбербанк.Вставить("Aw==", Новый Структура("Код, Описание", "03", Описание));
	Описание = НСтр("ru = 'Офис организации пользователя заблокирован.'");
	СписокКодовСбербанк.Вставить("BA==", Новый Структура("Код, Описание", "04", Описание));
	Описание = НСтр("ru = 'В аутентификации отказано ФРОД-мониторингом.'");
	СписокКодовСбербанк.Вставить("BQ==", Новый Структура("Код, Описание", "05", Описание));
	Описание = НСтр("ru = 'IP изменился.'");
	СписокКодовСбербанк.Вставить("Bg==", Новый Структура("Код, Описание", "06", Описание));
	Описание = НСтр("ru = 'Финансовый договор заблокирован.'");
	СписокКодовСбербанк.Вставить("Bw==", Новый Структура("Код, Описание", "07", Описание));
	Описание = НСтр("ru = 'Ошибка доступа к серверу.'");
	СписокКодовСбербанк.Вставить("CA==", Новый Структура("Код, Описание", "08", Описание));
	Описание = НСтр("ru = 'Не специфицированная ошибка.'");
	СписокКодовСбербанк.Вставить("CQ==", Новый Структура("Код, Описание", "09", Описание));
	Описание = НСтр("ru = 'Слишком частая ошибка входа в систему.'");
	СписокКодовСбербанк.Вставить("Cg==", Новый Структура("Код, Описание", "0A", Описание));
	Описание = НСтр("ru = 'Учетная запись отключена.'");
	СписокКодовСбербанк.Вставить("Cw==", Новый Структура("Код, Описание", "0B", Описание));
	Описание = НСтр("ru = 'Точка входа недоступна.'");
	СписокКодовСбербанк.Вставить("DA==", Новый Структура("Код, Описание", "0C", Описание));
	Описание = НСтр("ru = 'Ожидается заключение договора.'");
	СписокКодовСбербанк.Вставить("DQ==", Новый Структура("Код, Описание", "0D", Описание));
	Описание = НСтр("ru = 'Договор закрыт.'");
	СписокКодовСбербанк.Вставить("Dg==", Новый Структура("Код, Описание", "0E", Описание));
	Описание = НСтр("ru = 'Доступ закрыт настройками клиента.'");
	СписокКодовСбербанк.Вставить("Dw==", Новый Структура("Код, Описание", "0F", Описание));
	Описание = НСтр("ru = 'У пользователя в настройках отсутствует точка входа УПШ.'");
	СписокКодовСбербанк.Вставить("EA==", Новый Структура("Код, Описание", "10", Описание));
	Описание = НСтр("ru = 'У пользователя в настройках отсутствует точка входа УПШ_Холдинг.'");
	СписокКодовСбербанк.Вставить("EQ==", Новый Структура("Код, Описание", "11", Описание));
	Описание = НСтр("ru = 'Сертификат не найден в базе данных либо не привязан ни к одному пользователю.'");
	СписокКодовСбербанк.Вставить("Eg==", Новый Структура("Код, Описание", "12", Описание));
	Описание = НСтр("ru = 'Установленная сессия требует подтверждения кодом СМС.'");
	СписокКодовСбербанк.Вставить("Ew==", Новый Структура("Код, Описание", "13", Описание));
	Описание = НСтр("ru = 'Неверный код СМС.'");
	СписокКодовСбербанк.Вставить("FA==", Новый Структура("Код, Описание", "14", Описание));
	Описание = НСтр("ru = 'Срок действия кода СМС истек.'");
	СписокКодовСбербанк.Вставить("FQ==", Новый Структура("Код, Описание", "15", Описание));
	Описание = НСтр("ru = 'Неверные настройки СМС аутентификации.'");
	СписокКодовСбербанк.Вставить("Fg==", Новый Структура("Код, Описание", "16", Описание));
	Описание = НСтр("ru = 'Сессия не найдена.'");
	СписокКодовСбербанк.Вставить("Fw==", Новый Структура("Код, Описание", "17", Описание));
	Описание = НСтр("ru = 'Пользователь с указанными учетными данными должен использовать токен.'");
	СписокКодовСбербанк.Вставить("GA==", Новый Структура("Код, Описание", "18", Описание));
	Описание = НСтр("ru = 'Ошибка валидации параметров ФРОД-мониторинга при аутентификации.'");
	СписокКодовСбербанк.Вставить("GQ==", Новый Структура("Код, Описание", "19", Описание));
	Описание = НСтр("ru = 'Для организации недоступна точка входа «Банк-Клиент».'");
	СписокКодовСбербанк.Вставить("Gg==", Новый Структура("Код, Описание", "1А", Описание));
		
	ТекущаяОшибка = СписокКодовСбербанк.Получить(КодОшибки);
	
	Возврат ТекущаяОшибка;
	
КонецФункции

// Возвращает идентификатор внешней компоненты Сбербанка.
// 
// Возвращаемое значение:
//  Строка - идентификатор компоненты.
//
Функция ИдентификаторВнешнейКомпонентыСбербанк() Экспорт

	Возврат "VPNKeyTLS";
	
КонецФункции

#КонецОбласти

Процедура СообщитьПользователю(Знач ТекстСообщенияПользователю, Знач Поле = "", Знач ПутьКДанным = "", Отказ = Ложь)
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
	
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры


#КонецОбласти

