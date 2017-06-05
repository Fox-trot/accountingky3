﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаРабочееВремяСотрудников(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.ПериодРегистрации КАК Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.ВидРасчета,
		|	ТаблицаДокумента.Часов,
		|	СотрудникиСрезПоследних.Подразделение
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисления КАК ТаблицаДокумента
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники.СрезПоследних(&Дата, ) КАК СотрудникиСрезПоследних
		|			ПО ТаблицаДокумента.ФизЛицо = СотрудникиСрезПоследних.ФизЛицо
		|		ПО (ИСТИНА)";
	Запрос.УстановитьПараметр("Дата", СтруктураДополнительныеСвойства.ДляПроведения.Дата);
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРабочееВремяСотрудников", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаПлановыеНачисленияИУдержания()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.ПериодРегистрации,
		|	ТаблицаДокумента.Организация
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.РаботаСверхурочно КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.ВидРасчета,
		|	ТаблицаДокумента.Часов
		|ПОМЕСТИТЬ ВременнаяТаблицаНачисления
		|ИЗ
		|	Документ.РаботаСверхурочно.Сотрудники КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	
	СформироватьТаблицаРабочееВремяСотрудников(ДокументСсылка, СтруктураДополнительныеСвойства);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

Функция ПечатнаяФормаПриказаОСверхурочнойРаботе(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	РаботаСверхурочно.Ссылка,
		|	РаботаСверхурочно.ВерсияДанных,
		|	РаботаСверхурочно.ПометкаУдаления,
		|	РаботаСверхурочно.Номер как НомерДокумента,
		|	РаботаСверхурочно.Дата как ДатаДокумента,
		|	РаботаСверхурочно.Проведен,
		|	РаботаСверхурочно.ПериодРегистрации,
		|	РаботаСверхурочно.Организация,
		|	РаботаСверхурочно.Организация.НаименованиеПолное как НазваниеОрганизации,
		|	РаботаСверхурочно.Причина,
		|	РаботаСверхурочно.Комментарий,
		|	РаботаСверхурочно.Автор,
		|	РаботаСверхурочно.Сотрудники.(
		|		Ссылка,
		|		НомерСтроки,
		|		ФизЛицо,
		|		ВидРасчета,
		|	)
		|ИЗ
		|	Документ.РаботаСверхурочно КАК РаботаСверхурочно
		|ГДЕ
		|	РаботаСверхурочно.Ссылка В(&СписокДокументов)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "РаботаСверхурочно_ПриказОСверхурочнойРаботе";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РаботаСверхурочно.ПФ_MXL_ПриказОСверхурочнойРаботе");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("НазваниеОрганизации", Шапка.НазваниеОрганизации);
		ДанныеПечати.Вставить("НомерДокумента", Шапка.НомерДокумента);
		ДанныеПечати.Вставить("ДатаДокумента", Формат(Шапка.ДатаДокумента, "ДЛФ=D"));
		ДанныеПечати.Вставить("Причина", Шапка.Причина);
		
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Шапка");
		МассивОбластейМакета.Добавить("ДатаРаботы");
		МассивОбластейМакета.Добавить("Сотрудник");
		МассивОбластейМакета.Добавить("Подвал");
		МассивОбластейМакета.Добавить("Ознакомлен");
		
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если НЕ ИмяОбласти = "Сотрудник" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "Сотрудник" Тогда  
				
				ВыборкаПоСотрудникам = Шапка.Сотрудники.Выбрать();
				
				Пока ВыборкаПоСотрудникам.Следующий() Цикл 
					ОбластьМакета.Параметры.Заполнить(ВыборкаПоСотрудникам);
					
					ДанныеФизЛица = БухгалтерскийУчетСервер.ДанныеФизЛица(Шапка.Организация, ВыборкаПоСотрудникам.ФизЛицо, Шапка.ДатаДокумента);
					ОбластьМакета.Параметры.Должность 	= ДанныеФизЛица.Должность;
					ОбластьМакета.Параметры.ФИО			= ДанныеФизЛица.Представление;						
					
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;	
			КонецЕсли;
		КонецЦикла;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции	

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

	// печать Приказ о сверхурочной работе
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриказОСверхурочнойРаботе") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ПриказОСверхурочнойРаботе",
			НСтр("ru = 'Приказ о сверхурочной работе'"), 
			ПечатнаяФормаПриказаОСверхурочнойРаботе(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.РаботаСверхурочно.ПФ_MXL_ПриказОСверхурочнойРаботе");
	КонецЕсли;
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ о сверхурочной работе
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриказОСверхурочнойРаботе";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о сверхурочной работе'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
