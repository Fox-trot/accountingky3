﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСотрудникиПоТрудовымСоглашениям(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Период,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.Подразделение,
		|	ТаблицаДокумента.Должность,
		|	ЗНАЧЕНИЕ(Справочник.ГрафикиРаботы.Основной) КАК ГрафикРаботы,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием) КАК ВидСобытия
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ТаблицаДокумента
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ДатаОкончанияРаботы,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.Подразделение,
		|	ТаблицаДокумента.Должность,
		|	ЗНАЧЕНИЕ(Справочник.ГрафикиРаботы.Основной),
		|	ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ТаблицаДокумента";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСотрудникиПоТрудовымСоглашениям", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаСотрудники()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСтатусыСотрудников(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Период,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.Статус,
		|	ТаблицаДокумента.ДопВычет
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ТаблицаДокумента";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСтатусыСотрудников", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаСтатусыСотрудников()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаНачисления(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	ВременнаяТаблицаНачисленияПоПериодам = Новый ТаблицаЗначений;
	ВременнаяТаблицаНачисленияПоПериодам.Колонки.Добавить("ФизЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ВременнаяТаблицаНачисленияПоПериодам.Колонки.Добавить("ДатаНачала", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты()));
	ВременнаяТаблицаНачисленияПоПериодам.Колонки.Добавить("ДатаОкончания", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты()));
	ВременнаяТаблицаНачисленияПоПериодам.Колонки.Добавить("ПериодРегистрации", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты()));
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.Период КАК ДатаНачала,
		|	ТаблицаДокумента.ДатаОкончанияРаботы КАК ДатаОкончания
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ТаблицаДокумента";
	РезультатЗапроса = Запрос.Выполнить();	
	Выборка = РезультатЗапроса.Выбрать();	
	Пока Выборка.Следующий() Цикл 
		
		// Подготовить таблицу по периодам
		ПериодРегистрацииДатаОкончания = НачалоМесяца(Выборка.ДатаОкончания);
		
		Шаг = 0;
		Пока Истина Цикл 
			СтрокаТаблицы = ВременнаяТаблицаНачисленияПоПериодам.Добавить();
			СтрокаТаблицы.ФизЛицо = Выборка.ФизЛицо;
			
			СтрокаТаблицы.ДатаНачала = ?(Шаг = 0,  
				Выборка.ДатаНачала, 
				НачалоМесяца(ДобавитьМесяц(Выборка.ДатаНачала, Шаг)));
				
			СтрокаТаблицы.ПериодРегистрации = НачалоМесяца(СтрокаТаблицы.ДатаНачала);
	
			СтрокаТаблицы.ДатаОкончания = ?(СтрокаТаблицы.ПериодРегистрации = ПериодРегистрацииДатаОкончания, 
				Выборка.ДатаОкончания, 
				КонецМесяца(ДобавитьМесяц(Выборка.ДатаНачала, Шаг)));
			
			Если СтрокаТаблицы.ПериодРегистрации = ПериодРегистрацииДатаОкончания Тогда 
				Прервать;
			КонецЕсли;	
				
			Шаг = Шаг + 1;			
		КонецЦикла;	
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаНачисленияПоПериодам.ФизЛицо,
		|	ВременнаяТаблицаНачисленияПоПериодам.ДатаНачала,
		|	ВременнаяТаблицаНачисленияПоПериодам.ДатаОкончания,
		|	ВременнаяТаблицаНачисленияПоПериодам.ПериодРегистрации
		|ПОМЕСТИТЬ ВременнаяТаблицаНачисленияПоПериодам
		|ИЗ
		|	&ВременнаяТаблицаНачисленияПоПериодам КАК ВременнаяТаблицаНачисленияПоПериодам
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ПериодРегистрации,
		|	ТаблицаДокумента.ДатаНачала КАК ПериодДействияНачало,
		|	КОНЕЦПЕРИОДА(ТаблицаДокумента.ДатаОкончания, ДЕНЬ) КАК ПериодДействияКонец,
		|	ВременнаяТаблицаШапка.ВидРасчета,
		|	ВременнаяТаблицаШапка.СпособОтражения,
		|	ТаблицаДокумента.ФизЛицо,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Подразделение,
		|	ВременнаяТаблицаШапка.Должность,
		|	ВременнаяТаблицаШапка.Размер,
		|	ВременнаяТаблицаШапка.Размер КАК Результат,
		|	ЗНАЧЕНИЕ(Справочник.ГрафикиРаботы.Основной) КАК ГрафикРаботы
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисленияПоПериодам КАК ТаблицаДокумента
		|		ПО (ИСТИНА)";
	Запрос.УстановитьПараметр("ВременнаяТаблицаНачисленияПоПериодам", ВременнаяТаблицаНачисленияПоПериодам);

	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаНачисления", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаНачисления()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Период,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.Подразделение,
		|	ТаблицаДокумента.Должность,
		|	ТаблицаДокумента.ДатаОкончанияРаботы,
		|	ТаблицаДокумента.ВидРасчета,
		|	ТаблицаДокумента.СпособОтражения,
		|	ТаблицаДокумента.Размер,
		|	ТаблицаДокумента.Статус,
		|	ТаблицаДокумента.ДопВычет
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ТрудовоеСоглашение КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаСотрудникиПоТрудовымСоглашениям(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаСтатусыСотрудников(ДокументСсылка,СтруктураДополнительныеСвойства);
	СформироватьТаблицаНачисления(ДокументСсылка, СтруктураДополнительныеСвойства);
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

// Формирует запрос по документу.
//
Функция СформироватьЗапросДляПечати(ТекущийДокумент)
	Запрос = Новый Запрос;	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФизическиеЛицаКонтактнаяИнформация.Представление,
		|	ФизическиеЛицаКонтактнаяИнформация.Ссылка
		|ПОМЕСТИТЬ АдресСотрудника
		|ИЗ
		|	Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
		|ГДЕ
		|	ФизическиеЛицаКонтактнаяИнформация.Ссылка = &ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТрудовоеСоглашение.Дата КАК ДатаДокумента,
		|	ТрудовоеСоглашение.Номер КАК НомерДокумента,
		|	ТрудовоеСоглашение.Организация.НаименованиеПолное КАК ПредставлениеОрганизации,
		|	ТрудовоеСоглашение.Организация,
		|	ТрудовоеСоглашение.Подразделение,
		|	ТрудовоеСоглашение.Должность,
		|	ТрудовоеСоглашение.Комментарий КАК Основание,
		|	ТрудовоеСоглашение.Период КАК ДатаПриема,
		|	ТрудовоеСоглашение.ФизЛицо.ДатаРождения КАК ДатаРождения,
		|	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи,
		|	ДокументыФизическихЛицСрезПоследних.КемВыдан,
		|	ДокументыФизическихЛицСрезПоследних.Серия,
		|	ДокументыФизическихЛицСрезПоследних.ВидДокумента,
		|	ДокументыФизическихЛицСрезПоследних.Номер КАК Номер,
		|	АдресСотрудника.Представление КАК АдресСотрудника,
		|	ТрудовоеСоглашение.ДатаОкончанияРаботы,
		|	ТрудовоеСоглашение.Размер,
		|	ТрудовоеСоглашение.ФизЛицо.Наименование КАК Сотрудник,
		|	NULL КАК ПодписиДолжность,
		|	NULL КАК РасшифровкаПодписи
		|ИЗ
		|	Документ.ТрудовоеСоглашение КАК ТрудовоеСоглашение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(&Дата, ФизЛицо = &ФизЛицо) КАК ДокументыФизическихЛицСрезПоследних
		|		ПО ТрудовоеСоглашение.ФизЛицо = ДокументыФизическихЛицСрезПоследних.ФизЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ АдресСотрудника КАК АдресСотрудника
		|		ПО ТрудовоеСоглашение.ФизЛицо = АдресСотрудника.Ссылка
		|ГДЕ
		|	ТрудовоеСоглашение.Ссылка = &ТекущийДокумент";	
				
		Запрос.УстановитьПараметр("Дата", ТекущийДокумент.Дата);
		Запрос.УстановитьПараметр("ФизЛицо", ТекущийДокумент.ФизЛицо);		
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
		Возврат Запрос.Выполнить();
				
КонецФункции

// Формирует запрос по документу.
//
Функция СформироватьЗапросДляПечатиПриказа(ТекущийДокумент)
	Запрос = Новый Запрос;	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТрудовоеСоглашение.Дата КАК ДатаДокумента,
		|	ТрудовоеСоглашение.Номер КАК НомерДокумента,
		|	ТрудовоеСоглашение.Организация.НаименованиеПолное КАК Организация,
		|	ТрудовоеСоглашение.Подразделение,
		|	ТрудовоеСоглашение.Должность,
		|	ТрудовоеСоглашение.Период КАК ДатаС,
		|	ТрудовоеСоглашение.ДатаОкончанияРаботы КАК ДатаПо,
		|	ТрудовоеСоглашение.ФизЛицо.ДатаРождения КАК ДатаРождения,
		|	ТрудовоеСоглашение.ФизЛицо.ИНН КАК ИНН,
		|	ТрудовоеСоглашение.ФизЛицо.Код КАК ТабНомер,
		|	ГОД(&Дата) КАК ГодДок,
		|	ТрудовоеСоглашение.Размер КАК тариф,
		|	ТрудовоеСоглашение.Статус КАК Категория,
		|	ТрудовоеСоглашение.ФизЛицо.Наименование КАК Сотрудник,
		|	ТрудовоеСоглашение.ВидРасчета.Наименование КАК ФормаОплаты
		|ИЗ
		|	Документ.ТрудовоеСоглашение КАК ТрудовоеСоглашение
		|ГДЕ
		|	ТрудовоеСоглашение.Ссылка = &ТекущийДокумент";	
				
		Запрос.УстановитьПараметр("Дата", ТекущийДокумент.Дата);
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
		Возврат Запрос.Выполнить();
				
КонецФункции

// Сформировать печатные формы объектов
//
Функция ПечатьТрудовогоСоглашения(МассивОбъектов, ОбъектыПечати)
	Перем Ошибки;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ТрудовоеСоглашение_ТрудовойДоговор";     
	
	ПервыйДокумент = Истина;
	
	Для каждого  ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;    
		
		Выборка = СформироватьЗапросДляПечати(ТекущийДокумент).Выбрать();
		Выборка.Следующий();
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ТрудовоеСоглашение.ПФ_MXL_ТрудовойДоговор");
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.НомерДокумента);
		
		ОбластьМакета.Параметры.ДатаРождения = Формат(Выборка.ДатаРождения, "ДЛФ=DD");
		ОбластьМакета.Параметры.СтрокаДокумент = "" + Выборка.ВидДокумента + " " + Выборка.Серия + " №" + Выборка.Номер + " выдан " + Выборка.КемВыдан + " " + Формат(Выборка.ДатаВыдачи, "ДЛФ=DD");
		
		Если Не ЗначениеЗаполнено(Выборка.ДатаОкончанияРаботы) Тогда 
			ОбластьМакета.Параметры.СрокОпределенныйНеопределенный = НСтр("ru = '- на неопределенный срок;'");
		Иначе 
			ОбластьМакета.Параметры.СрокОпределенныйНеопределенный = НСтр("ru = '- на определённый срок;'");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ПодписиДолжность) Тогда 
			ОтборФЛ = Новый Структура;
			ОтборФЛ.Вставить("ФизЛицо", Выборка.РасшифровкаПодписи);
			ФИО = РегистрыСведений.ФИОФизическихЛиц.ПолучитьПоследнее(ТекущаяДата(),ОтборФЛ);
			
			ОбластьМакета.Параметры.ДолжностьРуководителя 	= Выборка.ПодписиДолжность;
			ОбластьМакета.Параметры.ФИОРуководителя 		= ФИО.Фамилия  + " " + Лев(ФИО.Имя,1) + ". " + Лев(ФИО.Отчество,1) + ".";
			
		Иначе 		
			Структура = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Выборка.Организация, Выборка.ДатаДокумента);
			Если НЕ Структура.Свойство("Руководитель") = Неопределено Тогда
				ОбластьМакета.Параметры.ДолжностьРуководителя 	= Структура.РуководительДолжность;
				ОбластьМакета.Параметры.ФИОРуководителя 		= Структура.Руководитель;		
			КонецЕсли;
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	Если НЕ Ошибки = Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	КонецЕсли;	
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатьТрудовогоСоглашения()

// Сформировать печатные формы объектов
//
Функция ПечатьПриказОПриемеНаРаботу(МассивОбъектов, ОбъектыПечати)
	Перем Ошибки;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ТрудовоеСоглашение_ПриказОПриемеНаРаботу";     
	
	ПервыйДокумент = Истина;
	
	Для каждого  ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
		Выборка = СформироватьЗапросДляПечатиПриказа(ТекущийДокумент).Выбрать();
		Выборка.Следующий();
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ТрудовоеСоглашение.ПФ_MXL_ПриказОПриемеНаРаботу");
		
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Данные");
		МассивОбластейМакета.Добавить("Подписи");
		
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти = "Данные" Тогда 
				ОбластьМакета.Параметры.Заполнить(Выборка);
				ОбластьМакета.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.НомерДокумента);
				ОбластьМакета.Параметры.ДатаРождения = Формат(Выборка.ДатаРождения, "ДЛФ=DD");
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
			Иначе
				ОбластьМакета.Параметры.ГодДок = Выборка.ГодДок;
				ТабличныйДокумент.Вывести(ОбластьМакета);
			КонецЕсли;	
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	Если НЕ Ошибки = Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	КонецЕсли;	
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатьТрудовогоСоглашения()

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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТрудовойДоговор") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ТрудовойДоговор", 
		НСтр("ru = 'Трудовой договор'"), 
		ПечатьТрудовогоСоглашения(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ТрудовоеСоглашение.ПФ_MXL_ТрудовойДоговор");
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриказОПриемеНаРаботу") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ПриказОПриемеНаРаботу", 
		НСтр("ru = 'Приказ о приеме на работу'"), 
		ПечатьПриказОПриемеНаРаботу(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ТрудовоеСоглашение.ПФ_MXL_ПриказОПриемеНаРаботу");
	КонецЕсли;

КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ТрудовойДоговор";
	КомандаПечати.Представление = НСтр("ru = 'Трудовой договор'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриказОПриемеНаРаботу";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о приеме на работу'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 2;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли