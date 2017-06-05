﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	Если Не ЗначениеЗаполнено(ПериодРегистрации) Тогда 
		ПериодРегистрации = ?(ЗначениеЗаполнено(Дата), НачалоМесяца(Дата), НачалоМесяца(ТекущаяДата()));
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

// В обработчике события ОбработкаПроверкиЗаполнения документа выполняется
// копирование и обнуление проверяемых реквизитов для исключения стандартной
// проверки заполнения платформой и последующей проверки средствами встроенного языка.
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
		|	ПлановыеНачисленияНачало.Регистратор,
		|	ПлановыеНачисленияНачало.Период,
		|	ПлановыеНачисленияНачало.ФизЛицо,
		|	ПлановыеНачисленияНачало.ВидРасчета,
		|	ПлановыеНачисленияНачало.Размер,
		|	ПлановыеНачисленияНачало.Подразделение,
		|	ПлановыеНачисленияНачало.Должность,
		|	ПлановыеНачисленияНачало.ГрафикРаботы
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
		|	ПлановыеНачисленияОкончаниеСрезПоследних.ФизЛицо,
		|	ПлановыеНачисленияОкончаниеСрезПоследних.ВидРасчета,
		|	ПлановыеНачисленияОкончаниеСрезПоследних.Период,
		|	ПлановыеНачисленияОкончаниеСрезПоследних.ДокументСсылка
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
		|	РабочееВремяСотрудниковОбороты.ФизЛицо,
		|	РабочееВремяСотрудниковОбороты.ВидРасчета,
		|	&НачалоПериода КАК ДатаНачала,
		|	&КонецПериода КАК ДатаОкончания,
		|	РабочееВремяСотрудниковОбороты.ДнейОборот КАК ОтработаноДней,
		|	РабочееВремяСотрудниковОбороты.ЧасовОборот КАК ОтработаноЧасов
		|ПОМЕСТИТЬ ВременнаяТаблицаРабочееВремяСотрудников
		|ИЗ
		|	РегистрНакопления.РабочееВремяСотрудников.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			,
		|			Организация = &Организация
		|				И Подразделение В ИЕРАРХИИ (&Подразделение)
		|				И ФизЛицо В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВременнаяТаблицаПлановыеНачисления.ФизЛицо
		|					ИЗ
		|						ВременнаяТаблицаПлановыеНачисления КАК ВременнаяТаблицаПлановыеНачисления)) КАК РабочееВремяСотрудниковОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаПлановыеНачисления.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаПлановыеНачисления.ФизЛицо.Наименование КАК ФизЛицоНаименовани,
		|	ВременнаяТаблицаПлановыеНачисления.ВидРасчета,
		|	ВременнаяТаблицаПлановыеНачисления.Размер,
		|	ВременнаяТаблицаПлановыеНачисления.Подразделение,
		|	ВременнаяТаблицаПлановыеНачисления.Должность,
		|	ВременнаяТаблицаПлановыеНачисления.ГрафикРаботы,
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
		|	ВременнаяТаблицаРабочееВремяСотрудников.ФизЛицо,
		|	ВременнаяТаблицаРабочееВремяСотрудников.ФизЛицо.Наименование,
		|	ВременнаяТаблицаРабочееВремяСотрудников.ВидРасчета,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	ВременнаяТаблицаРабочееВремяСотрудников.ДатаНачала,
		|	ВременнаяТаблицаРабочееВремяСотрудников.ДатаОкончания,
		|	ВременнаяТаблицаРабочееВремяСотрудников.ОтработаноДней,
		|	ВременнаяТаблицаРабочееВремяСотрудников.ОтработаноЧасов
		|ИЗ
		|	ВременнаяТаблицаРабочееВремяСотрудников КАК ВременнаяТаблицаРабочееВремяСотрудников
		|
		|УПОРЯДОЧИТЬ ПО
		|	ФизЛицоНаименовани";
	Если НЕ ЗначениеЗаполнено(Подразделение) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПлановыеНачисленияНачало.Подразделение В ИЕРАРХИИ(&Подразделение)", "ИСТИНА");
	КонецЕсли;			
		
	Запрос = Новый Запрос(ТекстЗапроса);	
	Запрос.УстановитьПараметр("Организация", Организация);	
	Запрос.УстановитьПараметр("Подразделение", Подразделение);	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодРегистрации));
	
	Начисления.Загрузить(Запрос.Выполнить().Выгрузить());
	
	СтруктураОтбора = ПроведениеРасчетовПоЗарплатеСервер.СтруктураОтбораДанныхСчетовУчетаПоЗП();
	
	// Определение счетов учета
	Для Каждого СтрокаТабличнойЧасти Из Начисления Цикл 
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, СтрокаТабличнойЧасти);
		СтруктураОтбора.ВидРасчетаНачисления = СтрокаТабличнойЧасти.ВидРасчета;
		
		ДанныеСчетаУчетаЗП = ПроведениеРасчетовПоЗарплатеСервер.ДанныеСчетаУчетаЗП(СтруктураОтбора);
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеСчетаУчетаЗП);		
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
	ПроведениеРасчетовПоЗарплатеСервер.РассчитатьЗаписиРегистраРасчета("Начисления", Движения.Начисления, Начисления, Ошибки);
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);	
	ЕстьОшибки = НЕ Ошибки = Неопределено;
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры // РассчитатьТабличнуюЧасть()

#КонецОбласти

#КонецЕсли
