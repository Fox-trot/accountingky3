﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	Если Не ЗначениеЗаполнено(ПериодРегистрации) Тогда 
		ПериодРегистрации = ?(ЗначениеЗаполнено(Дата), НачалоМесяца(Дата), НачалоМесяца(ТекущаяДатаСеанса()));
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.НачислениеЗарплаты.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьНачисления(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
		
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПроверяемыеРеквизиты.Добавить("Начисления");
		
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьТабличнуюЧасть() Экспорт 
	
	// 1. Плановые начисления, актуальные на начало месяца
	// 2. Пллановых начислений добавленные в течении месяца
	// 3. Окончание плановых начислений по п.1 и п.2	
	// 4. Дополнение по доп.начислениям из РН РабочееВремяСотрудников
	
	ТекстЗапроса =	
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	ПлановыеНачисленияНачало.Регистратор КАК Регистратор,
		|	ПлановыеНачисленияНачало.Период КАК Период,
		|	ПлановыеНачисленияНачало.ФизЛицо КАК ФизЛицо,
		|	ПлановыеНачисленияНачало.ВидРасчета КАК ВидРасчета,
		|	ПлановыеНачисленияНачало.Валюта КАК Валюта,
		|	ПлановыеНачисленияНачало.Размер КАК Размер,
		|	ПлановыеНачисленияНачало.Подразделение КАК Подразделение,
		|	ПлановыеНачисленияНачало.Должность КАК Должность,
		|	ПлановыеНачисленияНачало.ГрафикРаботы КАК ГрафикРаботы
		|ПОМЕСТИТЬ ВременнаяТаблицаПлановыеНачисления
		|ИЗ
		|	РегистрСведений.ПлановыеНачисленияНачало.СрезПоследних(ДОБАВИТЬКДАТЕ(&НачалоПериода, СЕКУНДА, -1), Организация = &Организация) КАК ПлановыеНачисленияНачало
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеНачисленияОкончание.СрезПоследних(ДОБАВИТЬКДАТЕ(&НачалоПериода, СЕКУНДА, -1), Организация = &Организация) КАК ПлановыеНачисленияОкончание
		|		ПО ПлановыеНачисленияНачало.Организация = ПлановыеНачисленияОкончание.Организация
		|			И ПлановыеНачисленияНачало.ФизЛицо = ПлановыеНачисленияОкончание.ФизЛицо
		|			И ПлановыеНачисленияНачало.ВидРасчета = ПлановыеНачисленияОкончание.ВидРасчета
		|			И ПлановыеНачисленияНачало.Регистратор = ПлановыеНачисленияОкончание.ДокументСсылка
		|ГДЕ
		|	ПлановыеНачисленияНачало.Подразделение В ИЕРАРХИИ(&Подразделение)
		|	И ПлановыеНачисленияОкончание.Организация ЕСТЬ NULL
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	2,
		|	ПлановыеНачисленияНачало.Регистратор,
		|	ПлановыеНачисленияНачало.Период,
		|	ПлановыеНачисленияНачало.ФизЛицо,
		|	ПлановыеНачисленияНачало.ВидРасчета,
		|	ПлановыеНачисленияНачало.Валюта,
		|	ПлановыеНачисленияНачало.Размер,
		|	ПлановыеНачисленияНачало.Подразделение,
		|	ПлановыеНачисленияНачало.Должность,
		|	ПлановыеНачисленияНачало.ГрафикРаботы
		|ИЗ
		|	РегистрСведений.ПлановыеНачисленияНачало КАК ПлановыеНачисленияНачало
		|ГДЕ
		|	ПлановыеНачисленияНачало.Период МЕЖДУ &НачалоПериода И &КонецПериода
		|	И ПлановыеНачисленияНачало.Организация = &Организация
		|	И ПлановыеНачисленияНачало.Подразделение В ИЕРАРХИИ(&Подразделение)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	3 КАК Порядок,
		|	ПлановыеНачисленияОкончаниеСрезПоследних.ФизЛицо КАК ФизЛицо,
		|	ПлановыеНачисленияОкончаниеСрезПоследних.ВидРасчета КАК ВидРасчета,
		|	ПлановыеНачисленияОкончаниеСрезПоследних.Период КАК Период,
		|	ПлановыеНачисленияОкончаниеСрезПоследних.ДокументСсылка КАК ДокументСсылка
		|ПОМЕСТИТЬ ВременнаяТаблицаПлановыеНачисленияОкончание
		|ИЗ
		|	РегистрСведений.ПлановыеНачисленияОкончание.СрезПоследних(
		|			&КонецПериода,
		|			Организация = &Организация
		|				И (ФизЛицо, ВидРасчета, ДокументСсылка) В
		|					(ВЫБРАТЬ
		|						ВременнаяТаблицаПлановыеНачисления.ФизЛицо,
		|						ВременнаяТаблицаПлановыеНачисления.ВидРасчета,
		|						ВременнаяТаблицаПлановыеНачисления.Регистратор
		|					ИЗ
		|						ВременнаяТаблицаПлановыеНачисления КАК ВременнаяТаблицаПлановыеНачисления)) КАК ПлановыеНачисленияОкончаниеСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	4 КАК Порядок,
		|	СведенияОРаботеСверхурочно.ФизЛицо КАК ФизЛицо,
		|	СведенияОРаботеСверхурочно.ВидРасчета КАК ВидРасчета,
		|	СведенияОРаботеСверхурочно.Валюта КАК Валюта,
		|	СведенияОРаботеСверхурочно.Подразделение КАК Подразделение,
		|	СведенияОРаботеСверхурочно.ДатаНачала КАК ДатаНачала,
		|	СведенияОРаботеСверхурочно.ДатаОкончания КАК ДатаОкончания,
		|	0 КАК ОтработаноДней,
		|	СУММА(СведенияОРаботеСверхурочно.Часов) КАК ОтработаноЧасов,
		|	СведенияОРаботеСверхурочно.РазмерОсновногоВидаРасчета КАК Размер
		|ПОМЕСТИТЬ ВременнаяТаблицаСведенияОРаботеСверхурочно
		|ИЗ
		|	РегистрСведений.СведенияОРаботеСверхурочно КАК СведенияОРаботеСверхурочно
		|ГДЕ
		|	СведенияОРаботеСверхурочно.Организация = &Организация
		|	И СведенияОРаботеСверхурочно.Подразделение = &Подразделение
		|	И СведенияОРаботеСверхурочно.ДатаНачала МЕЖДУ &НачалоПериода И &КонецПериода
		|	И СведенияОРаботеСверхурочно.ДатаОкончания МЕЖДУ &НачалоПериода И &КонецПериода
		|	И СведенияОРаботеСверхурочно.ФизЛицо В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				ВременнаяТаблицаПлановыеНачисления.ФизЛицо
		|			ИЗ
		|				ВременнаяТаблицаПлановыеНачисления КАК ВременнаяТаблицаПлановыеНачисления)
		|
		|СГРУППИРОВАТЬ ПО
		|	СведенияОРаботеСверхурочно.ФизЛицо,
		|	СведенияОРаботеСверхурочно.ВидРасчета,
		|	СведенияОРаботеСверхурочно.Валюта,
		|	СведенияОРаботеСверхурочно.Подразделение,
		|	СведенияОРаботеСверхурочно.ДатаНачала,
		|	СведенияОРаботеСверхурочно.ДатаОкончания,
		|	СведенияОРаботеСверхурочно.РазмерОсновногоВидаРасчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаПлановыеНачисления.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаПлановыеНачисления.ФизЛицо.Наименование КАК ФизЛицоНаименовани,
		|	ВременнаяТаблицаПлановыеНачисления.ВидРасчета КАК ВидРасчета,
		|	ВременнаяТаблицаПлановыеНачисления.Валюта КАК Валюта,
		|	ВременнаяТаблицаПлановыеНачисления.Размер КАК Размер,
		|	ВременнаяТаблицаПлановыеНачисления.Подразделение КАК Подразделение,
		|	ВременнаяТаблицаПлановыеНачисления.Должность КАК Должность,
		|	ВременнаяТаблицаПлановыеНачисления.ГрафикРаботы КАК ГрафикРаботы,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаПлановыеНачисления.Период < &НачалоПериода
		|			ТОГДА &НачалоПериода
		|		ИНАЧЕ ВременнаяТаблицаПлановыеНачисления.Период
		|	КОНЕЦ КАК ДатаНачала,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ВременнаяТаблицаПлановыеНачисленияОкончание.Период, &КонецПериода) > &КонецПериода
		|			ТОГДА &КонецПериода
		|		ИНАЧЕ ЕСТЬNULL(ВременнаяТаблицаПлановыеНачисленияОкончание.Период, &КонецПериода)
		|	КОНЕЦ КАК ДатаОкончания,
		|	0 КАК ОтработаноДней,
		|	0 КАК ОтработаноЧасов
		|ИЗ
		|	ВременнаяТаблицаПлановыеНачисления КАК ВременнаяТаблицаПлановыеНачисления
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаПлановыеНачисленияОкончание КАК ВременнаяТаблицаПлановыеНачисленияОкончание
		|		ПО ВременнаяТаблицаПлановыеНачисления.ФизЛицо = ВременнаяТаблицаПлановыеНачисленияОкончание.ФизЛицо
		|			И ВременнаяТаблицаПлановыеНачисления.ВидРасчета = ВременнаяТаблицаПлановыеНачисленияОкончание.ВидРасчета
		|			И ВременнаяТаблицаПлановыеНачисления.Регистратор = ВременнаяТаблицаПлановыеНачисленияОкончание.ДокументСсылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаСведенияОРаботеСверхурочно.ФизЛицо,
		|	ВременнаяТаблицаСведенияОРаботеСверхурочно.ФизЛицо.Наименование,
		|	ВременнаяТаблицаСведенияОРаботеСверхурочно.ВидРасчета,
		|	ВременнаяТаблицаСведенияОРаботеСверхурочно.Валюта,
		|	ВременнаяТаблицаСведенияОРаботеСверхурочно.Размер,
		|	ВременнаяТаблицаСведенияОРаботеСверхурочно.Подразделение,
		|	СотрудникиСрезПоследних.Должность,
		|	СотрудникиСрезПоследних.ГрафикРаботы,
		|	ВременнаяТаблицаСведенияОРаботеСверхурочно.ДатаНачала,
		|	ВременнаяТаблицаСведенияОРаботеСверхурочно.ДатаОкончания,
		|	ВременнаяТаблицаСведенияОРаботеСверхурочно.ОтработаноДней,
		|	ВременнаяТаблицаСведенияОРаботеСверхурочно.ОтработаноЧасов
		|ИЗ
		|	ВременнаяТаблицаСведенияОРаботеСверхурочно КАК ВременнаяТаблицаСведенияОРаботеСверхурочно
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники.СрезПоследних(
		|				&КонецПериода,
		|				Организация = &Организация
		|					И ФизЛицо В
		|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|							ВременнаяТаблицаПлановыеНачисления.ФизЛицо
		|						ИЗ
		|							ВременнаяТаблицаПлановыеНачисления КАК ВременнаяТаблицаПлановыеНачисления)) КАК СотрудникиСрезПоследних
		|		ПО ВременнаяТаблицаСведенияОРаботеСверхурочно.ФизЛицо = СотрудникиСрезПоследних.ФизЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	ФизЛицоНаименовани";
	Если НЕ ЗначениеЗаполнено(Подразделение) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПлановыеНачисленияНачало.Подразделение В ИЕРАРХИИ(&Подразделение)", "ИСТИНА");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СведенияОРаботеСверхурочно.Подразделение = &Подразделение", "ИСТИНА");
	КонецЕсли;			
		
	Запрос = Новый Запрос(ТекстЗапроса);	
	Запрос.УстановитьПараметр("Организация", Организация);	
	Запрос.УстановитьПараметр("Подразделение", Подразделение);	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодРегистрации));
	
	Начисления.Загрузить(Запрос.Выполнить().Выгрузить());
	
	СтруктураОтбора = ПроведениеРасчетовПоЗарплатеСервер.СтруктураОтбораСпособыОтраженияЗаработнойПлаты();
	
	// Определение способа отражения.
	Для Каждого СтрокаТабличнойЧасти Из Начисления Цикл 
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, СтрокаТабличнойЧасти);
		СтрокаТабличнойЧасти.СпособОтражения = ПроведениеРасчетовПоЗарплатеСервер.СпособОтраженияЗаработнойПлаты(СтруктураОтбора);		
	КонецЦикла;	
	
КонецПроцедуры // ЗаполнитьТабличнуюЧасть()

// Процедура рассчитывает табличную часть
//
Процедура РассчитатьТабличнуюЧасть(ЕстьОшибки) Экспорт

	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.НачислениеЗарплаты.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьНачисления(ДополнительныеСвойства, Движения, Ложь);

	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
	Ошибки = Неопределено;
	ПроведениеРасчетовПоЗарплатеСервер.РассчитатьЗаписиРегистраРасчета("Начисления", Движения.Начисления, Начисления, Ошибки,, ДополнительныеСвойства);
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);	
	ЕстьОшибки = НЕ Ошибки = Неопределено;
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры // РассчитатьТабличнуюЧасть()

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьТабличнуюЧастьПоВидуНачисления(СтруктураДанные) Экспорт 
	
	// Список работающих сотрудников.
	ТекстЗапроса =	
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизЛицо КАК ФизЛицо,
		|	СотрудникиСрезПоследних.ФизЛицо.Наименование КАК ФизЛицоНаименование,
		|	&ВидРасчета КАК ВидРасчета,
		|	&Размер КАК Размер,
		|	СотрудникиСрезПоследних.Подразделение КАК Подразделение,
		|	СотрудникиСрезПоследних.Должность КАК Должность,
		|	СотрудникиСрезПоследних.ГрафикРаботы КАК ГрафикРаботы,
		|	&НачалоПериода КАК ДатаНачала,
		|	&КонецПериода КАК ДатаОкончания
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&НачалоПериода, Организация = &Организация) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	СотрудникиСрезПоследних.Подразделение В ИЕРАРХИИ(&Подразделение)
		|	И НЕ СотрудникиСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Сотрудники.ФизЛицо,
		|	Сотрудники.ФизЛицо.Наименование,
		|	&ВидРасчета,
		|	&Размер,
		|	Сотрудники.Подразделение,
		|	Сотрудники.Должность,
		|	Сотрудники.ГрафикРаботы,
		|	&НачалоПериода,
		|	&КонецПериода
		|ИЗ
		|	РегистрСведений.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Организация = &Организация
		|	И Сотрудники.Подразделение В ИЕРАРХИИ(&Подразделение)
		|	И Сотрудники.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием)
		|	И Сотрудники.Период МЕЖДУ &НачалоПериода И &КонецПериода
		|
		|УПОРЯДОЧИТЬ ПО
		|	ФизЛицоНаименование";
	Если НЕ ЗначениеЗаполнено(Подразделение) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СотрудникиСрезПоследних.Подразделение В ИЕРАРХИИ(&Подразделение)", "ИСТИНА");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Сотрудники.Подразделение В ИЕРАРХИИ(&Подразделение)", "ИСТИНА");
	КонецЕсли;			
		
	Запрос = Новый Запрос(ТекстЗапроса);	
	Запрос.УстановитьПараметр("Организация", Организация);	
	Запрос.УстановитьПараметр("Подразделение", Подразделение);	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("ВидРасчета", СтруктураДанные.ВидРасчета);
	Запрос.УстановитьПараметр("Размер", СтруктураДанные.Размер);
	
	Начисления.Загрузить(Запрос.Выполнить().Выгрузить());
	
	СтруктураОтбора = ПроведениеРасчетовПоЗарплатеСервер.СтруктураОтбораСпособыОтраженияЗаработнойПлаты();
	
	// Определение счетов учета
	Для Каждого СтрокаТабличнойЧасти Из Начисления Цикл 
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, СтрокаТабличнойЧасти);
		СтрокаТабличнойЧасти.СпособОтражения = ПроведениеРасчетовПоЗарплатеСервер.СпособОтраженияЗаработнойПлаты(СтруктураОтбора);
	КонецЦикла;	
	
КонецПроцедуры // ЗаполнитьТабличнуюЧасть()

#КонецОбласти

#КонецЕсли
