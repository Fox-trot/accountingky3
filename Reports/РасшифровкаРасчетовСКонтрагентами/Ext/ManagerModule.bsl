﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Для подсистемы "Варианты отчетов" при работе в модели сервиса.
//
// Возвращаемое значение:
//  Массив - массив структур (варианты отчета).
Функция ВариантыНастроек() Экспорт
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("Имя, Представление","РасшифровкаРасчетовСКонтрагентами", НСтр("ru = 'Расшифровка расчетов с контрагентами'")));
	Возврат Массив;
КонецФункции

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РасшифровкаРасчетовСКонтрагентами");
	НастройкиВарианта.Описание = НСтр("ru = 'Расшифровка расчетов с контрагентами'");

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);
	
	Возврат Результат;

КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Расшифровка расчетов с контрагентами" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	СписокСчетов = БухгалтерскиеОтчетыВызовСервераПовтИсп.СчетаРасчетовСКонтрагентами();
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаУчетаРасчетовСКонтрагентами", СписокСчетов);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаОстатки", НачалоДня(ПараметрыОтчета.НачалоПериода) + 1);
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаОстатки", Дата(1, 1, 1) + 1);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаОстатки", КонецДня(ПараметрыОтчета.КонецПериода) + 1);
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаОстатки", Дата(3999, 1, 1) + 1);
	КонецЕсли;
	
	// Группировка
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировки(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
		
	// Добавляем отбор по Контрагенту.
	Если ЗначениеЗаполнено(ПараметрыОтчета.Контрагент) Тогда
		ОтборПоКонтрагенту = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборПоКонтрагенту.ЛевоеЗначение 		= Новый ПолеКомпоновкиДанных("Контрагент");
		ОтборПоКонтрагенту.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ОтборПоКонтрагенту.ПравоеЗначение 		= ПараметрыОтчета.Контрагент;
		ОтборПоКонтрагенту.Использование 		= Истина;
		ОтборПоКонтрагенту.РежимОтображения 	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;	
	КонецЕсли;
		
	// Добавляем отбор по Договору контрагента.
	Если ЗначениеЗаполнено(ПараметрыОтчета.Контрагент) Тогда
		ОтборПоДоговору = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборПоДоговору.ЛевоеЗначение 		= Новый ПолеКомпоновкиДанных("ДоговорКонтрагента");
		ОтборПоДоговору.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ОтборПоДоговору.ПравоеЗначение 		= ПараметрыОтчета.ДоговорКонтрагента;
		ОтборПоДоговору.Использование 		= Истина;
		ОтборПоДоговору.РежимОтображения 	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;	
	КонецЕсли;		
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	ОбластьЯчеек = Результат.НайтиТекст("<ОстатокНаНачало>");
	Если ОбластьЯчеек <> Неопределено Тогда
		
		ТекстЯчейки = НСтр("ru = 'Остаток на %1'");
		
		ОбластьЯчеек.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЯчейки, Формат(ПараметрыОтчета.НачалоПериода, "ДФ=dd.MM.yy; ДП=..."));;
		ОбластьЯчеек = Результат.Область(ОбластьЯчеек.Верх, ОбластьЯчеек.Лево, ОбластьЯчеек.Верх + 1, ОбластьЯчеек.Лево + 7);
		ОбластьЯчеек.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
		
	КонецЕсли;
		
	ОбластьЯчеек = Результат.НайтиТекст("<ОстатокНаКонец>");
	Если ОбластьЯчеек <> Неопределено Тогда
		
		ТекстЯчейки = НСтр("ru = 'Остаток на %1'");
		
		ОбластьЯчеек.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЯчейки, Формат(ПараметрыОтчета.КонецПериода, "ДФ=dd.MM.yy; ДП=..."));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	// Инициализируем список мунктов меню
	СписокПунктовМеню = Новый СписокЗначений();
	
	// Заполним соответствие полей которые мы хотим получить из данных расшифровки
	СоответствиеПолей = Новый Соответствие;
	ДанныеОтчета = ПолучитьИзВременногоХранилища(Адрес);
	
	ЗначениеРасшифровки = ДанныеОтчета.ДанныеРасшифровки.Элементы[Расшифровка];
	Если ТипЗнч(ЗначениеРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для Каждого ПолеРасшифровки Из ЗначениеРасшифровки.ПолучитьПоля() Цикл
			Если ЗначениеЗаполнено(ПолеРасшифровки.Значение) Тогда
				ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
				ПараметрыРасшифровки.Вставить("Значение",  ПолеРасшифровки.Значение);
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Укажем что открывать объект сразу не нужно
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
	Если ДанныеОтчета = Неопределено Тогда 
		ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
		Возврат;
	КонецЕсли;
	
	// Инициализация пользовательских настроек
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("РежимРасшифровки", 					Истина);
	ДополнительныеСвойства.Вставить("Организация", 							ДанныеОтчета.Объект.Организация);
	ДополнительныеСвойства.Вставить("НачалоПериода", 						ДанныеОтчета.Объект.НачалоПериода);
	ДополнительныеСвойства.Вставить("КонецПериода", 						ДанныеОтчета.Объект.КонецПериода);
	ДополнительныеСвойства.Вставить("ВыводитьЗаголовок",					ДанныеОтчета.Объект.ВыводитьЗаголовок);
	ДополнительныеСвойства.Вставить("ВыводитьПодвал",						ДанныеОтчета.Объект.ВыводитьПодвал);
	ДополнительныеСвойства.Вставить("МакетОформления",						ДанныеОтчета.Объект.МакетОформления);
	
	// Получаем соответствие полей доступных в расшифровке
	Данные_Расшифровки = БухгалтерскиеОтчеты.ПолучитьДанныеРасшифровки(ДанныеОтчета.ДанныеРасшифровки, СоответствиеПолей, Расшифровка);
	
	Договор = Данные_Расшифровки.Получить("Договор");
	
	Если ЗначениеЗаполнено(Договор) Тогда
		
		ДополнительныеСвойства.Вставить("Организация", Договор.Организация);
		
	КонецЕсли;
	
	ОтборПоЗначениямРасшифровки = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ОтборПоЗначениямРасшифровки.ИдентификаторПользовательскойНастройки = "Отбор";
	
	Для Каждого ЗначениеРасшифровки Из Данные_Расшифровки Цикл
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборПоЗначениямРасшифровки, ЗначениеРасшифровки.Ключ, ЗначениеРасшифровки.Значение);
		
	КонецЦикла;
	
	СписокПунктовМеню.Добавить("РасшифровкаРасчетовСКонтрагентами", "Расшифровка расчетов с контрагентами");
	
	НастройкиРасшифровки = Новый Структура();
	НастройкиРасшифровки.Вставить("РасшифровкаРасчетовСКонтрагентами", ПользовательскиеНастройки);
	ДанныеОтчета.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	
	ПоместитьВоВременноеХранилище(ДанныеОтчета, Адрес);
	
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	
КонецПроцедуры

// Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал"                   , Ложь);
	КоллекцияНастроек.Вставить("МакетОформления"                  , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"        , Неопределено);
	КоллекцияНастроек.Вставить("Контрагент"                       , Справочники.Контрагенты.ПустаяСсылка());
	КоллекцияНастроек.Вставить("ДоговорКонтрагента"               , Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает структуру параметров, наличие которых требуется для успешного формирования отчета.
//
// Возвращаемое значение:
//   Структура - структура параметров для формирования отчета.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("ПериодОтчета"         , Неопределено);
	ПараметрыОтчета.Вставить("НачалоПериода"        , Дата(1,1,1));
	ПараметрыОтчета.Вставить("КонецПериода"         , Дата(1,1,1));
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	
	Возврат ПараметрыОтчета;
	
КонецФункции

#КонецОбласти

#КонецЕсли
