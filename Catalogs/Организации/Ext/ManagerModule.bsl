﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Префикс");
	Результат.Добавить("КонтактнаяИнформация.*");
	
	Возврат Результат
КонецФункции

// Возвращает организацию по умолчанию.
// Если в ИБ есть только одна организация, которая не помечена на удаление и не является предопределенной,
// то будет возвращена ссылка на нее, иначе будет возвращена пустая ссылка.
//
// Возвращаемое значение:
//     СправочникСсылка.Организации - ссылка на организацию
//
Функция ОрганизацияПоУмолчанию() Экспорт
	Возврат БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация");
КонецФункции

// Возвращает количество элементов справочника Организации.
// Не учитывает предопределенные и помеченные на удаление элементы.
//
// Возвращаемое значение:
//     Число - количество организаций
//
Функция КоличествоОрганизаций() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Количество = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.Предопределенный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Количество = Выборка.Количество;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Количество;
	
КонецФункции

// Возвращает значение функциональной опции 
// "ИспользоватьНесколькоОрганизацийБухгалтерскийУчет".
//
// Возвращаемое значение:
//     Булево - признак использования нескольких организаций.
//
Функция ИспользуетсяНесколькоОрганизаций() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("УчетПоНесколькимОрганизациям");
	
КонецФункции

// Процедура - Дополнить данные заполнения при однофирменном учете
//
// Параметры:
//  ДанныеЗаполнения		 - 	 - 
//  ИмяРеквизитаОрганизация	 - 	 - 
//
Процедура ДополнитьДанныеЗаполненияПриОднофирменномУчете(ДанныеЗаполнения, ИмяРеквизитаОрганизация = "Организация") Экспорт
	
	Если ИспользуетсяНесколькоОрганизаций() Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполнения = Новый Структура;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДанныеЗаполнения.Свойство(ИмяРеквизитаОрганизация) Тогда
		ОрганизацияПоУмолчанию = ОрганизацияПоУмолчанию();
		ПроверитьНаличиеОрганизацииПриОднофирменномУчете(ОрганизацияПоУмолчанию);
		ДанныеЗаполнения.Вставить(ИмяРеквизитаОрганизация, ОрганизацияПоУмолчанию);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие хотя бы одной организации при ведении однофирменного учета.
//
Процедура ПроверитьНаличиеОрганизацииПриОднофирменномУчете(Организация) Экспорт
	
	Если ИспользуетсяНесколькоОрганизаций() Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		ТекстСообщения = НСтр("ru = 'Заполните реквизиты организации'") + Символы.ПС;
		ПутьКРазделу = НСтр("ru = '(раздел Настройки - Параметры учета - Справочник ""Организации"")'");
		
		ТекстСообщения = ТекстСообщения + ПутьКРазделу;
		
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
Процедура ЗаполнитьПоУмолчанию() Экспорт
	СправочникМенеджер = Справочники.Организации;
	
	КлассификаторXML = СправочникМенеджер.ПолучитьМакет("МакетЗаполнения").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл 
		Наименование = СокрЛП(СтрокаТаблицыЗначений.Наименование);
		
		СправочникСсылка = СправочникМенеджер.НайтиПоНаименованию(Наименование, Истина);
		
		Если СправочникСсылка.Пустая() Тогда 
			СправочникОбъект = СправочникМенеджер.СоздатьЭлемент();
		Иначе
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		КонецЕсли;	
		
		СправочникОбъект.Наименование = Наименование;
		
		БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект,,,,Истина);
	КонецЦикла;
КонецПроцедуры // ЗаполнитьПоУмолчанию()	

#КонецОбласти

#Область ИнтерфейсПечати

// Процедура формирования табличного документа с реквизитами организаций
//
Функция ПечатьКарточкиОрганизации(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Организация_КарточкаОрганизации";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.Организации.РеквизитыОрганизации");
	Разделитель = Макет.ПолучитьОбласть("Разделитель");
	
	ТекДата = ТекущаяДатаСеанса();
	ПервыйДокумент = Истина;
	
	Для каждого Организация Из МассивОбъектов Цикл
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.Вывести(Разделитель);
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СведенияОбОрганизации = БухгалтерскийУчетСервер.ПолучитьСведенияОбОрганизации(Организация, ТекДата);
		
		Область = Макет.ПолучитьОбласть("Наименование");
		Область.Параметры.ПолноеНаименование = СведенияОбОрганизации.НаименованиеПолное;
		ТабличныйДокумент.Вывести(Область);
		
		Если ЗначениеЗаполнено(СведенияОбОрганизации.ИНН) Тогда
			Область = Макет.ПолучитьОбласть("ИНН");
			Область.Параметры.ИНН = СведенияОбОрганизации.ИНН;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СведенияОбОрганизации.ОКПО) Тогда
			Область = Макет.ПолучитьОбласть("ОКПО");
			Область.Параметры.КодПоОКПО = СведенияОбОрганизации.ОКПО;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СведенияОбОрганизации.НомерСчета) 
			И ЗначениеЗаполнено(СведенияОбОрганизации.БИКБанка) 
			И ЗначениеЗаполнено(СведенияОбОрганизации.КоррСчетБанка) 
			И ЗначениеЗаполнено(СведенияОбОрганизации.Банк) Тогда
			
			Область = Макет.ПолучитьОбласть("РасчетныйСчет");
			Область.Параметры.НомерСчета = СведенияОбОрганизации.НомерСчета;
			Область.Параметры.БИК = СведенияОбОрганизации.БИКБанка;
			Область.Параметры.КоррСчет = СведенияОбОрганизации.КоррСчетБанка;
			Область.Параметры.Банк = СведенияОбОрганизации.Банк;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СведенияОбОрганизации.АдрЮР) 
			ИЛИ ЗначениеЗаполнено(СведенияОбОрганизации.Тел) Тогда
			ТабличныйДокумент.Вывести(Разделитель);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СведенияОбОрганизации.АдрЮР) Тогда
			Область = Макет.ПолучитьОбласть("ЮридическийАдрес");
			Область.Параметры.ЮридическийАдрес = СведенияОбОрганизации.АдрЮР;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
			
		Если ЗначениеЗаполнено(СведенияОбОрганизации.Тел) Тогда
			Область = Макет.ПолучитьОбласть("Телефон");
			Область.Параметры.Телефон = СведенияОбОрганизации.Тел;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Организация);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Процедура формирования макета печати
//
Функция СформироватьПомощникРаботыФаксимильнойПечати(МасиивОрганизаций, ОбъектыПечати, ИмяМакета)
	
	ТабличныйДокумент	= Новый ТабличныйДокумент;
	Макет				= УправлениеПечатью.МакетПечатнойФормы("Справочник.Организации." + ИмяМакета);
	
	Для каждого Организация Из МасиивОрганизаций Цикл 
	
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("ПоляКЗаполнению"));
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Линия"));
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Схема"));
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 1, ОбъектыПечати, Организация);
	
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;

КонецФункции // СформироватьПомощникРаботыФаксимильнойПечати()

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РеквизитыОрганизации") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"РеквизитыОрганизации",
			НСтр("ru='Реквизиты организации'"),
			ПечатьКарточкиОрганизации(МассивОбъектов, ОбъектыПечати));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НапечататьПомощникСозданияФаксимилеПечати") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"НапечататьПомощникСозданияФаксимилеПечати",
			НСтр("ru='Как быстро и просто создать факсимиле печати?'"),
			СформироватьПомощникРаботыФаксимильнойПечати(МассивОбъектов, ОбъектыПечати, "ПомощникСозданияФаксимилеПечати"));
		
	КонецЕсли;
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ПредварительныйПросмотрПечатнойФормыСчетНаОплату");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
		//ПечатнаяФорма.ПолныйПутьКМакету = Обработки.ПечатьСчетНаОплату.ПолныйПутьКМакету();
		//ПечатнаяФорма.СинонимМакета = Обработки.ПечатьСчетНаОплату.ПредставлениеПФ(Ложь);
		
		//ДанныеОбъектовПечати = УниверсальныйЗапросПоДаннымДокумента(МассивОбъектов);
		//Обработки.ПечатьСчетНаОплату.СформироватьПФ(ПечатнаяФорма, ДанныеОбъектовПечати, ОбъектыПечати, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РеквизитыОрганизации";
	КомандаПечати.Представление = НСтр("ru = 'Реквизиты'");
	КомандаПечати.СписокФорм = "ФормаЭлемента,ФормаСписка";
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Печать реквизитов организации'");
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
