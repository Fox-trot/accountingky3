﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСотрудники(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВременнаяТаблицаШапка.Период,
	|	ВременнаяТаблицаШапка.Организация,
	|	ВременнаяТаблицаШапка.ФизЛицо,
	|	СотрудникиСрезПоследних.Подразделение,
	|	СотрудникиСрезПоследних.Должность,
	|	СотрудникиСрезПоследних.ЗанимаемыхСтавок,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение) КАК ВидСобытия,
	|	СотрудникиСрезПоследних.ГрафикРаботы,
	|	СотрудникиСрезПоследних.Регистратор КАК Ссылка
	|ИЗ
	|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСотрудникиСрезПоследних КАК СотрудникиСрезПоследних
	|		ПО (ИСТИНА)";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Период", ДокументСсылка.ДатаУвольнения);
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСотрудники", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаСотрудники()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПлановыеНачисленияОкончание(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// 1. Таблица по всем видам начисления
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	ВременнаяТаблицаШапка.Период КАК Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	ВременнаяТаблицаСрезПлановыеНачисленияНачалоАктуально.ВидРасчета,
		|	ВременнаяТаблицаСрезПлановыеНачисленияНачалоАктуально.Размер,
		|	ВременнаяТаблицаСрезПлановыеНачисленияНачалоАктуально.Регистратор КАК ДокументСсылка,
		|	ВременнаяТаблицаСрезПлановыеНачисленияНачалоАктуально.Основной
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСрезПлановыеНачисленияНачалоАктуально КАК ВременнаяТаблицаСрезПлановыеНачисленияНачалоАктуально
		|		ПО (ИСТИНА)";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлановыеНачисленияОкончание", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаПлановыеНачисленияОкончание()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПлановыеУдержанияОкончание(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	ВременнаяТаблицаСрезПлановыеУдержанияНачалоАктуально.ВидРасчета,
		|	ВременнаяТаблицаСрезПлановыеУдержанияНачалоАктуально.Регистратор КАК ДокументСсылка,
		|	ВременнаяТаблицаСрезПлановыеУдержанияНачалоАктуально.Размер
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСрезПлановыеУдержанияНачалоАктуально КАК ВременнаяТаблицаСрезПлановыеУдержанияНачалоАктуально
		|		ПО (ИСТИНА)";
	Запрос.УстановитьПараметр("Период", ДокументСсылка.ДатаУвольнения);
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлановыеУдержанияОкончание", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаПлановыеУдержанияОкончание()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.ДатаУвольнения КАК Период,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ФизЛицо КАК ФизЛицо
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.Увольнение КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизЛицо КАК ФизЛицо,
		|	СотрудникиСрезПоследних.Подразделение КАК Подразделение,
		|	СотрудникиСрезПоследних.Должность КАК Должность,
		|	СотрудникиСрезПоследних.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
		|	СотрудникиСрезПоследних.ГрафикРаботы КАК ГрафикРаботы,
		|	СотрудникиСрезПоследних.Регистратор КАК Регистратор
		|ПОМЕСТИТЬ ВременнаяТаблицаСотрудникиСрезПоследних
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&Период,
		|			(Организация, ФизЛицо) В
		|					(ВЫБРАТЬ
		|						ТаблицаДокумента.Организация,
		|						ТаблицаДокумента.ФизЛицо
		|					ИЗ
		|						ВременнаяТаблицаШапка КАК ТаблицаДокумента)
		|				И НЕ Регистратор = &Ссылка) КАК СотрудникиСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПлановыеНачисленияНачалоСрезПоследних.Регистратор КАК Регистратор,
		|	ПлановыеНачисленияНачалоСрезПоследних.ВидРасчета КАК ВидРасчета,
		|	ПлановыеНачисленияНачалоСрезПоследних.Размер КАК Размер,
		|	ПлановыеНачисленияНачалоСрезПоследних.Основной КАК Основной
		|ПОМЕСТИТЬ ВременнаяТаблицаСрезПлановыеНачисленияНачалоАктуально
		|ИЗ
		|	РегистрСведений.ПлановыеНачисленияНачало.СрезПоследних(
		|			&Период,
		|			(Организация, ФизЛицо) В
		|					(ВЫБРАТЬ
		|						ВременнаяТаблицаШапка.Организация,
		|						ВременнаяТаблицаШапка.ФизЛицо
		|					ИЗ
		|						ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка)
		|				И НЕ Регистратор = &Ссылка) КАК ПлановыеНачисленияНачалоСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеНачисленияОкончание.СрезПоследних(
		|				&Период,
		|				(Организация, ФизЛицо) В
		|						(ВЫБРАТЬ
		|							ВременнаяТаблицаШапка.Организация,
		|							ВременнаяТаблицаШапка.ФизЛицо
		|						ИЗ
		|							ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка)
		|					И НЕ Регистратор = &Ссылка) КАК ПлановыеНачисленияОкончаниеСрезПоследних
		|		ПО ПлановыеНачисленияНачалоСрезПоследних.Организация = ПлановыеНачисленияОкончаниеСрезПоследних.Организация
		|			И ПлановыеНачисленияНачалоСрезПоследних.ФизЛицо = ПлановыеНачисленияОкончаниеСрезПоследних.ФизЛицо
		|			И ПлановыеНачисленияНачалоСрезПоследних.ВидРасчета = ПлановыеНачисленияОкончаниеСрезПоследних.ВидРасчета
		|			И ПлановыеНачисленияНачалоСрезПоследних.Регистратор = ПлановыеНачисленияОкончаниеСрезПоследних.ДокументСсылка
		|ГДЕ
		|	ПлановыеНачисленияОкончаниеСрезПоследних.Организация ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПлановыеУдержанияНачалоСрезПоследних.Регистратор КАК Регистратор,
		|	ПлановыеУдержанияНачалоСрезПоследних.ВидРасчета КАК ВидРасчета,
		|	ПлановыеУдержанияНачалоСрезПоследних.Размер КАК Размер
		|ПОМЕСТИТЬ ВременнаяТаблицаСрезПлановыеУдержанияНачалоАктуально
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияНачало.СрезПоследних(
		|			&Период,
		|			(Организация, ФизЛицо) В
		|				(ВЫБРАТЬ
		|					ВременнаяТаблицаШапка.Организация,
		|					ВременнаяТаблицаШапка.ФизЛицо
		|				ИЗ
		|					ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка)) КАК ПлановыеУдержанияНачалоСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеУдержанияОкончание.СрезПоследних(
		|				&Период,
		|				(Организация, ФизЛицо) В
		|						(ВЫБРАТЬ
		|							ВременнаяТаблицаШапка.Организация,
		|							ВременнаяТаблицаШапка.ФизЛицо
		|						ИЗ
		|							ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка)
		|					И НЕ Регистратор = &Ссылка) КАК ПлановыеУдержанияОкончаниеСрезПоследних
		|		ПО ПлановыеУдержанияНачалоСрезПоследних.Организация = ПлановыеУдержанияОкончаниеСрезПоследних.Организация
		|			И ПлановыеУдержанияНачалоСрезПоследних.ФизЛицо = ПлановыеУдержанияОкончаниеСрезПоследних.ФизЛицо
		|			И ПлановыеУдержанияНачалоСрезПоследних.ВидРасчета = ПлановыеУдержанияОкончаниеСрезПоследних.ВидРасчета
		|			И ПлановыеУдержанияНачалоСрезПоследних.Регистратор = ПлановыеУдержанияОкончаниеСрезПоследних.ДокументСсылка
		|ГДЕ
		|	ПлановыеУдержанияОкончаниеСрезПоследних.Организация ЕСТЬ NULL";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Период", ДокументСсылка.ДатаУвольнения);
	
	Запрос.Выполнить();
	
	СформироватьТаблицаСотрудники(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаПлановыеНачисленияОкончание(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаПлановыеУдержанияОкончание(ДокументСсылка, СтруктураДополнительныеСвойства);
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

// Сформировать печатные формы объектов
//
Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Увольнение.Ссылка КАК Ссылка,
		|	Увольнение.Дата КАК ДатаПриказа,
		|	Увольнение.Номер КАК НомерПриказа,
		|	Увольнение.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	Увольнение.Организация.КодПоОКПО КАК КодПоОКПО,
		|	Увольнение.Организация КАК Организация,
		|	Увольнение.ФизЛицо.ФИО КАК ФИОСотрудника,
		|	Увольнение.ФизЛицо.Код КАК ТабНом,
		|	Увольнение.ОснованиеУвольнения.Наименование КАК ОснованиеУвольненияНаименование,
		|	Увольнение.СтатьяТрудовогоКодекса.Наименование КАК СтатьяТрудовогоКодексаНаименование,
		|	Увольнение.СтатьяТрудовогоКодекса.Основание КАК СтатьяТрудовогоКодексаОснование,
		|	СотрудникиСрезПоследних.Подразделение.Наименование КАК ПодразделениеНаименование,
		|	СотрудникиСрезПоследних.Должность.Наименование КАК ДолжностьНаименование,
		|	Увольнение.Комментарий КАК Дополнительно,
		|	Увольнение.ДатаУвольнения КАК ДатаУвольнения
		|ИЗ
		|	Документ.Увольнение КАК Увольнение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники.СрезПоследних(, Регистратор В (&СписокДокументов)) КАК СотрудникиСрезПоследних
		|		ПО Увольнение.Ссылка = СотрудникиСрезПоследних.Регистратор
		|			И Увольнение.ФизЛицо = СотрудникиСрезПоследних.ФизЛицо
		|ГДЕ
		|	Увольнение.Ссылка В(&СписокДокументов)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "Увольнение_ПриказОбУвольнении";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Увольнение.ПФ_MXL_ПриказОбУвольнении");
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("НомерПриказа", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерПриказа));
		ДанныеПечати.Вставить("ДатаПриказа", Формат(Шапка.ДатаПриказа,"ДЛФ=ДД"));
		ДанныеПечати.Вставить("КодПоОКПО", Шапка.КодПоОКПО);
		ДанныеПечати.Вставить("ТабНом", СокрЛП(Шапка.ТабНом));
		ДанныеПечати.Вставить("ОрганизацияНаименованиеПолное", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("ФИОСотрудника", Шапка.ФИОСотрудника);
		ДанныеПечати.Вставить("ПодразделениеНаименование", Шапка.ПодразделениеНаименование);
		ДанныеПечати.Вставить("ДолжностьНаименование", Шапка.ДолжностьНаименование);
		ДанныеПечати.Вставить("ОснованиеУвольненияНаименование", Шапка.ОснованиеУвольненияНаименование);
		ДанныеПечати.Вставить("СтатьяТрудовогоКодексаНаименование", Шапка.СтатьяТрудовогоКодексаНаименование);
		ДанныеПечати.Вставить("СтатьяТрудовогоКодексаОснование", Шапка.СтатьяТрудовогоКодексаОснование);
		ДанныеПечати.Вставить("ДатаУвольнения", Формат(Шапка.ДатаУвольнения,"ДЛФ=ДД"));
		ДанныеПечати.Вставить("Дополнительно", Шапка.Дополнительно);
					
		Структура = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Шапка.Организация, Шапка.ДатаПриказа);
		Если НЕ Структура.Свойство("Руководитель") = Неопределено Тогда
			ДанныеПечати.Вставить("ДолжностьРуководителя", Структура.РуководительДолжность);
			ДанныеПечати.Вставить("ФИОРуководителя", Структура.Руководитель);
		КонецЕсли;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
			
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриказОбУвольнении") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ПриказОбУвольнении", 
		НСтр("ru = 'Приказ об увольнении'"), 
		ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "ПриказОбУвольнении"));
	КонецЕсли;

КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриказОбУвольнении";
	КомандаПечати.Представление = НСтр("ru = 'Приказ об увольнении'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;

КонецПроцедуры

#КонецОбласти
	
#КонецЕсли