﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       см. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина);
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "");
	НастройкиВарианта.Описание = НСтр("ru = 'Общий отчет об использование бланков счет-фактур НДС.'");

	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
		НСтр("ru = 'КОД и НАИМЕНОВАНИЕ НАЛОГОВОГО ОРГАНА
		|СЕРИЯ И №ПАСПОРТА
		|ПОЧТ.ИНДЕКС
		|№ ТЕЛЕФОНА
		|НОМЕР НАЦСТАТКОМА
		|ОБЛАСТЬ, ГОРОД/ОБЛ., РАЙОН, СЕЛО
		|УЛИЦА/МИКР., № ДОМА, КВАРТИРЫ
		|НАЛОГОВЫЙ ПЕРИОД С
		|НАЛОГОВЫЙ ПЕРИОД ПО
		|ЭЛЕКТРОННОГО ЗАПОЛНЕНИЯ
		|Необл.сумма
		|Всего
		|ИНН облагаемого субъекта
		|Наименование облагаемого субъекта
		|Код налогового органа
		|Наименование налогового органа
		|Отчетный период с
		|Отчетный период по
		|Остаток на начало отчетного периода
		|Получено
		|Использовано
		|Утеряно
		|Испорчено
		|Производственный брак
		|Остаток на конец отчетного периода
		|Всего
		|Количество комплектов
		|Ручного заполнения А4 Серия
		|Ручного заполнения А4  с номера по номер
		|Ручного заполнения А5 Серия
		|Ручного заполнения А5  с номера по номер
		|Принтерного заполнения А4 Серия
		|Принтерного заполнения А4  с номера по номер
		|Принтерного заполнения А5 Серия
		|Принтерного заполнения А5  с номера по номер
		|Дата подачи ОТЧЕТА
		|Индентификационный номер плательщика
		|Наименование предприятия
		|Юридический адрес предприятия
		|№
		|Наименование
		|Кол-во комплек - тов
		|ручное заполнение
		|компьютерное заполнение
		|Номера бланков
		|Руководитель предприятия
		|Главный бухгалтер'");
		
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов =
		НСтр("ru = 'НачалоПериода
		|КонецПериода
		|Ландшафт
		|Подробный
		|Организация'");
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Общий отчет об использование бланков счет-фактур НДС'");
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Процедура формирования отчета.
//
// Параметры:
// ПараметрыОтчета - структура - набор параметров, необходимых для построения отчета.
// 	АдресХранилища - адрес временного хранилища.
Процедура Сформировать(СтруктураПараметров, АдресХранилища) Экспорт
	
	РезультатФормирования = Новый Структура("Результат, ОписаниеОшибки", Неопределено, "");
	
	Если СтруктураПараметров.Ландшафт Тогда
		СформироватьТабличныйДокументЛандшафт(СтруктураПараметров, РезультатФормирования)
	ИначеЕсли СтруктураПараметров.Подробный Тогда
		СформироватьТабличныйДокументПодробный(СтруктураПараметров, РезультатФормирования);
	Иначе
		СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования);
	КонецЕсли;
	ПоместитьВоВременноеХранилище(РезультатФормирования, АдресХранилища);
	
КонецПроцедуры

// Процедура - Сформировать табличный документ
//
// Параметры:
//  СтруктураПараметров	 - Структура - Параметры формирования отчета.
//  РезультатФормирования	 	- Структура - 
//
//	Формирует отчет по макету "ПФ_MXL_БланкИспользованных"
Процедура СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "БланкиСФОтчетОбИспользовании_БланкИспользованных";
	
	Организация = СтруктураПараметров.Организация;
	НачалоПериода = СтруктураПараметров.НачалоПериода;
	КонецПериода = СтруктураПараметров.КонецПериода;
	
	Макет = ПолучитьМакет("ПФ_MXL_БланкИспользованных");

	ОКПО              				= Организация.КодПоОКПО;
	ИНН 							= Организация.ИНН;
	КодГНС 							= Организация.ГНС.Код;
	ОрганизацияНаменованиеПолное    = Организация.НаименованиеПолное;
	
	
	КонтактныеДанные = ПолучитьКонтактнуюИнформацию(Организация);
	
	Индекс           = КонтактныеДанные.Индекс;
	АдрОбластьГород  = КонтактныеДанные.АдрОбластьГород;
	ЮрАдрес	         = КонтактныеДанные.АдресОрганизации; 
	Телефон		     = КонтактныеДанные.Телефон;
	
	НомерЯйки = 210;	

	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	
	ОбластьШапка.Параметры.НаименованиеОрганизации = ОрганизацияНаменованиеПолное;
	Если ЗначениеЗаполнено(АдрОбластьГород) Тогда 
		ОбластьШапка.Параметры.Область = АдрОбластьГород;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЮрАдрес) Тогда 
		ОбластьШапка.Параметры.Адрес = ЮрАдрес;
	КонецЕсли;
	
	ОбластьШапка.Параметры.Телефон = Телефон;
	
	Если ЗначениеЗаполнено(Индекс) ТОгда
		ОбластьШапка.Параметры.ИНД1 = Сред(Индекс,1,1);
		ОбластьШапка.Параметры.ИНД2 = Сред(Индекс,2,1);
		ОбластьШапка.Параметры.ИНД3 = Сред(Индекс,3,1);
		ОбластьШапка.Параметры.ИНД4 = Сред(Индекс,4,1);
		ОбластьШапка.Параметры.ИНД5 = Сред(Индекс,5,1);
		ОбластьШапка.Параметры.ИНД6 = Сред(Индекс,6,1);
	КонецЕсли;

	Если ЗначениеЗаполнено(ОКПО) Тогда 
		ОбластьШапка.Параметры.ОКПО1 = Сред(ОКПО,1,1);
		ОбластьШапка.Параметры.ОКПО2 = Сред(ОКПО,2,1);
		ОбластьШапка.Параметры.ОКПО3 = Сред(ОКПО,3,1);
		ОбластьШапка.Параметры.ОКПО4 = Сред(ОКПО,4,1);
		ОбластьШапка.Параметры.ОКПО5 = Сред(ОКПО,5,1);
		ОбластьШапка.Параметры.ОКПО6 = Сред(ОКПО,6,1);
		ОбластьШапка.Параметры.ОКПО7 = Сред(ОКПО,7,1);
		ОбластьШапка.Параметры.ОКПО8 = Сред(ОКПО,8,1);
	КонецЕсли;
	
	ОбластьШапка.Параметры.ИНН1 = Сред(ИНН, 1, 1);
	ОбластьШапка.Параметры.ИНН2 = Сред(ИНН, 2, 1);
	ОбластьШапка.Параметры.ИНН3 = Сред(ИНН, 3, 1);                           
	ОбластьШапка.Параметры.ИНН4 = Сред(ИНН, 4, 1);
	ОбластьШапка.Параметры.ИНН5 = Сред(ИНН, 5, 1);
	ОбластьШапка.Параметры.ИНН6 = Сред(ИНН, 6, 1);
	ОбластьШапка.Параметры.ИНН7 = Сред(ИНН, 7, 1);
	ОбластьШапка.Параметры.ИНН8 = Сред(ИНН, 8, 1);
	ОбластьШапка.Параметры.ИНН9 = Сред(ИНН, 9, 1);
	ОбластьШапка.Параметры.ИНН10 = Сред(ИНН, 10, 1);
	ОбластьШапка.Параметры.ИНН11 = Сред(ИНН, 11, 1);
	ОбластьШапка.Параметры.ИНН12 = Сред(ИНН, 12, 1);
	ОбластьШапка.Параметры.ИНН13 = Сред(ИНН, 13, 1);
	ОбластьШапка.Параметры.ИНН14 = Сред(ИНН, 14, 1);
	
	ОбластьШапка.Параметры.НаименованиеНалоговой = Организация.ГНС;
	
	ОбластьШапка.Параметры.Код1 = Сред(КодГНС, 1, 1);
	ОбластьШапка.Параметры.Код2 = Сред(КодГНС, 2, 1);
	ОбластьШапка.Параметры.Код3 = Сред(КодГНС, 3, 1);
	
	ОбластьШапка.Параметры.ДН1 = Сред(НачалоПериода, 1, 1);	
	ОбластьШапка.Параметры.ДН2 = Сред(НачалоПериода, 2, 1);	
	ОбластьШапка.Параметры.ДН3 = Сред(НачалоПериода, 4, 1);	
	ОбластьШапка.Параметры.ДН4 = Сред(НачалоПериода, 5, 1);	
	ОбластьШапка.Параметры.ДН5 = Сред(НачалоПериода, 7, 1);	
	ОбластьШапка.Параметры.ДН6 = Сред(НачалоПериода, 8, 1);	
	ОбластьШапка.Параметры.ДН7 = Сред(НачалоПериода, 9, 1);	
	ОбластьШапка.Параметры.ДН8 = Сред(НачалоПериода, 10, 1);	
	
	ОбластьШапка.Параметры.ДК1 = Сред(КонецПериода, 1, 1);	
	ОбластьШапка.Параметры.ДК2 = Сред(КонецПериода, 2, 1);	
	ОбластьШапка.Параметры.ДК3 = Сред(КонецПериода, 4, 1);	
	ОбластьШапка.Параметры.ДК4 = Сред(КонецПериода, 5, 1);	
	ОбластьШапка.Параметры.ДК5 = Сред(КонецПериода, 7, 1);	
	ОбластьШапка.Параметры.ДК6 = Сред(КонецПериода, 8, 1);	
	ОбластьШапка.Параметры.ДК7 = Сред(КонецПериода, 9, 1);	
	ОбластьШапка.Параметры.ДК8 = Сред(КонецПериода, 10, 1);
	
	ОбластьТаблица	= Макет.ПолучитьОбласть("Таблица");	
	
	Запрос = Новый Запрос;
	ТекстЗапроса =		
		"ВЫБРАТЬ
		|	БланкиСФОстатки.Операция,
		|	БланкиСФОстатки.КоличествоОстаток
		|ПОМЕСТИТЬ Остатки_КонецПериода
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Остатки(&КонецПериода, Организация = &Организация) КАК БланкиСФОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	БланкиСФОстатки.Операция,
		|	БланкиСФОстатки.КоличествоОстаток
		|ПОМЕСТИТЬ Остатки_НачалоПериода
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Остатки(&НачалоПериода, Организация = &Организация) КАК БланкиСФОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	БланкиСФОбороты.Операция,
		|	БланкиСФОбороты.КоличествоПриход,
		|	БланкиСФОбороты.КоличествоРасход
		|ПОМЕСТИТЬ Обороты
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(&НачалоПериода, &КонецПериода, Авто, Организация = &Организация) КАК БланкиСФОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(Остатки_НачалоПериода.КоличествоОстаток) КАК ОстатокНВсего
		|ИЗ
		|	Остатки_НачалоПериода КАК Остатки_НачалоПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(Остатки_КонецПериода.КоличествоОстаток) КАК ОстатокКВсего
		|ИЗ
		|	Остатки_КонецПериода КАК Остатки_КонецПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(Обороты.КоличествоПриход) КАК ПолученоВсего
		|ИЗ
		|	Обороты КАК Обороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(ВЫБОР
		|			КОГДА Обороты.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.ИспользованиеБланковСФ)
		|				ТОГДА Обороты.КоличествоРасход
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ИспользованоВсего,
		|	СУММА(ВЫБОР
		|			КОГДА Обороты.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.ПорчаБланковСФ)
		|				ТОГДА Обороты.КоличествоРасход
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ИспорченоВсего,
		|	СУММА(ВЫБОР
		|			КОГДА Обороты.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.УтеряБланковСФ)
		|				ТОГДА Обороты.КоличествоРасход
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК УтеряноВсего,
		|	СУММА(ВЫБОР
		|			КОГДА Обороты.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.ПроизводственныйБракБланковСФ)
		|				ТОГДА Обороты.КоличествоРасход
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК БракВсего
		|ИЗ
		|	Обороты КАК Обороты";
	Запрос.УстановитьПараметр("НачалоПериода",	НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",	КонецДня(КонецПериода));
	Если ЗначениеЗаполнено(Организация) Тогда
		Запрос.УстановитьПараметр("Организация", Организация);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Организация = &Организация", "Истина");
	КонецЕсли;		
	
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	// 1. Остатки на начало
	ВыборкаОстатокН = РезультатЗапроса[3].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если ВыборкаОстатокН.Следующий() Тогда
		ОбластьТаблица.Параметры.Заполнить(ВыборкаОстатокН);
	КонецЕсли;
	
	// 2. Получено
	ВыборкаПолучено = РезультатЗапроса[5].Выбрать();
	Если ВыборкаПолучено.Следующий() Тогда
		ОбластьТаблица.Параметры.Заполнить(ВыборкаПолучено);
	КонецЕсли;
		
	// 3. Использовано, Утеряно, Испорчено, брак	
	ВыборкаСФ = РезультатЗапроса[6].Выбрать();
	Если ВыборкаСФ.Следующий() Тогда
		ОбластьТаблица.Параметры.Заполнить(ВыборкаСФ);
	КонецЕсли;
	
	// 4. остатки на конец
	ВыборкаОстаток = РезультатЗапроса[4].Выбрать();
	Если ВыборкаОстаток.Следующий() Тогда
		ОбластьТаблица.Параметры.Заполнить(ВыборкаОстаток);
	КонецЕсли;
	
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ТабличныйДокумент.Вывести(ОбластьШапка);
	ТабличныйДокумент.Вывести(ОбластьТаблица);
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
	РезультатФормирования.Результат = ТабличныйДокумент;
КонецПроцедуры

// Функция -ПолучитьКонтактнуюИнформацию
//
// Параметры:
//  Организация  - Спр.Ссылка - Спр.Органинизации 
// Возвращаемое значение:
//  Структура   - структура данных контактной информации
//
Функция ПолучитьКонтактнуюИнформацию(Организация)
	
	СведенияОбОрганизации = БухгалтерскийУчетСервер.ПолучитьСведенияОбОрганизации(Организация);

	Индекс = СведенияОбОрганизации.Индекс; 
	
	ГородНасПункт   = ?(СведенияОбОрганизации.Город  = "",СведенияОбОрганизации.НаселенныйПункт,СведенияОбОрганизации.Город);
	АдрОбластьГород = ?(СведенияОбОрганизации.Регион = "","",СведенияОбОрганизации.Регион + ",")
		+ ?(СведенияОбОрганизации.Район  = "","", " " + СведенияОбОрганизации.Район + ",") 
		+ ?(ГородНасПункт = "",""," " + ГородНасПункт); 
	АдресОрганизации = ?(СведенияОбОрганизации.Улица    = "","",СведенияОбОрганизации.Улица + ",")
		+ ?(СведенияОбОрганизации.Дом      = "",""," " + СведенияОбОрганизации.Дом + ",")
		+ ?(СведенияОбОрганизации.Корпус   = "",""," " + СведенияОбОрганизации.Корпус + ",")
		+ ?(СведенияОбОрганизации.Квартира = "",""," " + СведенияОбОрганизации.Квартира);
		
	Телефон = СведенияОбОрганизации.Тел;
	
	Структура = Новый Структура("Индекс,АдрОбластьГород,АдресОрганизации,Телефон", Индекс,АдрОбластьГород,АдресОрганизации,Телефон);
	
	Возврат Структура;
	
КонецФункции // ПолучитьАдресОрганизации()

// Процедуры с концовкой "...Ландшафт" формируют отчет по макету "ПФ_MXL_БланкИспользованныхЛандшафт"
//
Процедура СформироватьТабличныйДокументЛандшафт(СтруктураПараметров, РезультатФормирования) 
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "БланкиСФОтчетОбИспользовании_БланкИспользованныхЛандшафт";
	
	Организация = СтруктураПараметров.Организация;
	НачалоПериода = СтруктураПараметров.НачалоПериода;
	КонецПериода = СтруктураПараметров.КонецПериода;
	
	Макет = ПолучитьМакет("ПФ_MXL_БланкИспользованныхЛандшафт");

	ИНН 							= Организация.ИНН;
	КодГНС 							= Организация.ГНС.Код;
	ОрганизацияНаменованиеПолное    = Организация.НаименованиеПолное;

	ОбластьШапка					= Макет.ПолучитьОбласть("Шапка");	
	ОбластьОстатокНачало			= Макет.ПолучитьОбласть("ОстатокНачало");
	ОбластьПолучено					= Макет.ПолучитьОбласть("Получено");
	ОбластьИспользовано				= Макет.ПолучитьОбласть("Использовано");
	ОбластьУтеряно					= Макет.ПолучитьОбласть("Утеряно");
	ОбластьИспорчено				= Макет.ПолучитьОбласть("Испорчено");
	ОбластьПроизводственныйБрак		= Макет.ПолучитьОбласть("ПроизводственныйБрак");
	ОбластьОстатокКонец				= Макет.ПолучитьОбласть("ОстатокКонец");
	ОбластьПодвал					= Макет.ПолучитьОбласть("Подвал");
	
	ОбластьШапка.Параметры.НаменованиеОрганизации = ОрганизацияНаменованиеПолное;
	
	ОбластьШапка.Параметры.ИНН1 = Сред(ИНН, 1, 1);
	ОбластьШапка.Параметры.ИНН2 = Сред(ИНН, 2, 1);
	ОбластьШапка.Параметры.ИНН3 = Сред(ИНН, 3, 1);                           
	ОбластьШапка.Параметры.ИНН4 = Сред(ИНН, 4, 1);
	ОбластьШапка.Параметры.ИНН5 = Сред(ИНН, 5, 1);
	ОбластьШапка.Параметры.ИНН6 = Сред(ИНН, 6, 1);
	ОбластьШапка.Параметры.ИНН7 = Сред(ИНН, 7, 1);
	ОбластьШапка.Параметры.ИНН8 = Сред(ИНН, 8, 1);
	ОбластьШапка.Параметры.ИНН9 = Сред(ИНН, 9, 1);
	ОбластьШапка.Параметры.ИНН10 = Сред(ИНН, 10, 1);
	ОбластьШапка.Параметры.ИНН11 = Сред(ИНН, 11, 1);
	ОбластьШапка.Параметры.ИНН12 = Сред(ИНН, 12, 1);
	ОбластьШапка.Параметры.ИНН13 = Сред(ИНН, 13, 1);
	ОбластьШапка.Параметры.ИНН14 = Сред(ИНН, 14, 1);
	
	ОбластьШапка.Параметры.НаименованиеНалоговой = Организация.ГНС;
	
	ОбластьШапка.Параметры.Код1 = Сред(КодГНС, 1, 1);
	ОбластьШапка.Параметры.Код2 = Сред(КодГНС, 2, 1);
	ОбластьШапка.Параметры.Код3 = Сред(КодГНС, 3, 1);
	
	ОбластьШапка.Параметры.ДН1 = Сред(НачалоПериода, 1, 1);	
	ОбластьШапка.Параметры.ДН2 = Сред(НачалоПериода, 2, 1);	
	ОбластьШапка.Параметры.ДН3 = Сред(НачалоПериода, 4, 1);	
	ОбластьШапка.Параметры.ДН4 = Сред(НачалоПериода, 5, 1);	
	ОбластьШапка.Параметры.ДН5 = Сред(НачалоПериода, 7, 1);	
	ОбластьШапка.Параметры.ДН6 = Сред(НачалоПериода, 8, 1);	
	ОбластьШапка.Параметры.ДН7 = Сред(НачалоПериода, 9, 1);	
	ОбластьШапка.Параметры.ДН8 = Сред(НачалоПериода, 10, 1);	
	
	ОбластьШапка.Параметры.ДК1 = Сред(КонецПериода, 1, 1);	
	ОбластьШапка.Параметры.ДК2 = Сред(КонецПериода, 2, 1);	
	ОбластьШапка.Параметры.ДК3 = Сред(КонецПериода, 4, 1);	
	ОбластьШапка.Параметры.ДК4 = Сред(КонецПериода, 5, 1);	
	ОбластьШапка.Параметры.ДК5 = Сред(КонецПериода, 7, 1);	
	ОбластьШапка.Параметры.ДК6 = Сред(КонецПериода, 8, 1);	
	ОбластьШапка.Параметры.ДК7 = Сред(КонецПериода, 9, 1);	
	ОбластьШапка.Параметры.ДК8 = Сред(КонецПериода, 10, 1);
	
	ТабличныйДокумент.Вывести(ОбластьШапка);
	
	Запрос = Новый Запрос;
	Запрос.Текст =		
		"ВЫБРАТЬ
		|	СУММА(БланкиСФОстатки.КоличествоОстаток) КАК КоличествоВсего,
		|	БланкиСФОстатки.Серия КАК Серия,
		|	БланкиСФОстатки.Номер КАК БланкНомер
		|ПОМЕСТИТЬ ОстаткиНачало
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Остатки(&НачалоПериода, Организация = &Организация) КАК БланкиСФОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОстатки.Номер,
		|	БланкиСФОстатки.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БланкиСФОстатки.КоличествоОстаток) КАК КоличествоВсего,
		|	БланкиСФОстатки.Номер КАК БланкНомер,
		|	БланкиСФОстатки.Серия КАК Серия
		|ПОМЕСТИТЬ ОстаткиКонец
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Остатки(&КонецПериода, Организация = &Организация) КАК БланкиСФОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОстатки.Серия,
		|	БланкиСФОстатки.Номер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиНачало.КоличествоВсего КАК КоличествоВсего,
		|	ОстаткиНачало.Серия КАК Серия,
		|	ОстаткиНачало.БланкНомер КАК БланкНомер
		|ИЗ
		|	ОстаткиНачало КАК ОстаткиНачало
		|ГДЕ
		|	ОстаткиНачало.КоличествоВсего > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего),
		|	МИНИМУМ(БланкНомер)
		|ПО
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиКонец.КоличествоВсего КАК КоличествоВсего,
		|	ОстаткиКонец.БланкНомер КАК БланкНомер,
		|	ОстаткиКонец.Серия КАК Серия
		|ИЗ
		|	ОстаткиКонец КАК ОстаткиКонец
		|ГДЕ
		|	ОстаткиКонец.КоличествоВсего > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего),
		|	МИНИМУМ(БланкНомер)
		|ПО
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БланкиСФОбороты.КоличествоПриход) КАК КоличествоВсего,
		|	БланкиСФОбороты.Номер КАК БланкНомер,
		|	БланкиСФОбороты.Серия КАК Серия
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.ПриходБланковСФ)) КАК БланкиСФОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОбороты.Номер,
		|	БланкиСФОбороты.Серия
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего),
		|	МИНИМУМ(БланкНомер)
		|ПО
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БланкиСФОбороты.КоличествоРасход) КАК КоличествоВсего,
		|	БланкиСФОбороты.Номер КАК БланкНомер,
		|	БланкиСФОбороты.Серия КАК Серия
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.ИспользованиеБланковСФ)) КАК БланкиСФОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОбороты.Номер,
		|	БланкиСФОбороты.Серия
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего),
		|	МИНИМУМ(БланкНомер)
		|ПО
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БланкиСФОбороты.КоличествоРасход) КАК КоличествоВсего,
		|	БланкиСФОбороты.Номер КАК БланкНомер,
		|	БланкиСФОбороты.Серия КАК Серия
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.УтеряБланковСФ)) КАК БланкиСФОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОбороты.Номер,
		|	БланкиСФОбороты.Серия
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего),
		|	МИНИМУМ(БланкНомер)
		|ПО
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БланкиСФОбороты.КоличествоРасход) КАК КоличествоВсего,
		|	БланкиСФОбороты.Номер КАК БланкНомер,
		|	БланкиСФОбороты.Серия КАК Серия
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.ПорчаБланковСФ)) КАК БланкиСФОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОбороты.Номер,
		|	БланкиСФОбороты.Серия
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего),
		|	МИНИМУМ(БланкНомер)
		|ПО
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БланкиСФОбороты.КоличествоРасход) КАК КоличествоВсего,
		|	БланкиСФОбороты.Номер КАК БланкНомер,
		|	БланкиСФОбороты.Серия КАК Серия
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.ПроизводственныйБракБланковСФ)) КАК БланкиСФОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОбороты.Номер,
		|	БланкиСФОбороты.Серия
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего),
		|	МИНИМУМ(БланкНомер)
		|ПО
		|	Серия";

	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(НачалоПериода));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(КонецПериода));	
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Запрос.УстановитьПараметр("Организация", Организация);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Организация = &Организация", "Истина");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ПараметрыВыборки = Новый Структура;
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[2]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьОстатокНачало);	
	ОбработкаРезультатаЗапросаЛандшафт(ТабличныйДокумент, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[4]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьПолучено);
	ОбработкаРезультатаЗапросаЛандшафт(ТабличныйДокумент, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[5]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьИспользовано);
	ОбработкаРезультатаЗапросаЛандшафт(ТабличныйДокумент, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[6]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьУтеряно);
	ОбработкаРезультатаЗапросаЛандшафт(ТабличныйДокумент, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[7]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьИспорчено);
	ОбработкаРезультатаЗапросаЛандшафт(ТабличныйДокумент, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[8]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьПроизводственныйБрак);
	ОбработкаРезультатаЗапросаЛандшафт(ТабличныйДокумент, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[3]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьОстатокКонец);	
	ОбработкаРезультатаЗапросаЛандшафт(ТабличныйДокумент, ПараметрыВыборки);	
	
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
	РезультатФормирования.Результат = ТабличныйДокумент;
	
КонецПроцедуры

Процедура ОбработкаРезультатаЗапросаЛандшафт(ТабличныйДокумент, ПараметрыВыборки)
	Пакет 	= ПараметрыВыборки.Пакет;
	Область = ПараметрыВыборки.Область;
	
	//СерияА4Р = "";
	//СерияА5Р = "";
	//СерияА4П = "";
	//СерияА5П = "";
	//ИнтервалыСерийА4Р = "";
	//ИнтервалыСерийА5Р = "";
	//ИнтервалыСерийА4П = "";
	//ИнтервалыСерийА5П = "";
	//ПараметрыИнтервалов = Новый Структура;
	
	ОбщееКолво = 0;
	
	ПредыдущийНомер = -100; // Здесь надо ставить любой заведомо не реальный номер;
	
	ВыборкаСерии = Пакет.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСерии.Следующий() Цикл
		Серия 					= ВыборкаСерии.Серия;
		//Ручные 					= ВыборкаСерии.Ручные;
		//Формат 					= ВыборкаСерии.Формат;
		НомерОт 				= ВыборкаСерии.БланкНомер;
		ПредыдущийНомер 		= Число(ВыборкаСерии.БланкНомер) - 1;
		ПервыйНомерИнтервала	= ВыборкаСерии.БланкНомер;
		ПоследнийНомерИнтервала	= Число(ВыборкаСерии.БланкНомер);
		ОбщееКолво 				= ОбщееКолво + ВыборкаСерии.КоличествоВсего;		
		
		//ПараметрыИнтервалов.Вставить("Ручные", Ручные);
		//ПараметрыИнтервалов.Вставить("Формат", Формат);
		//ПараметрыИнтервалов.Вставить("ИнтервалыСерийА4Р", ИнтервалыСерийА4Р);
		//ПараметрыИнтервалов.Вставить("ИнтервалыСерийА5Р", ИнтервалыСерийА5Р);
		//ПараметрыИнтервалов.Вставить("ИнтервалыСерийА4П", ИнтервалыСерийА4П);
		//ПараметрыИнтервалов.Вставить("ИнтервалыСерийА5П", ИнтервалыСерийА5П);
		//ИнтервалыСерии 			= ПолучитьНужныйИнтервалСерийЛандшафт(ПараметрыИнтервалов);
		ПервыйИнтервалСерии 	= Истина;
		ВыборкаНомера 			= ВыборкаСерии.Выбрать();
		//СтруктураИнтервала 		= Новый Структура;
		Пока ВыборкаНомера.Следующий() Цикл
			ПроверяемыйНомер = Число(ВыборкаНомера.БланкНомер);
			Если ПроверяемыйНомер = (ПредыдущийНомер + 1) Тогда
				ПредыдущийНомер = ПроверяемыйНомер;
				ПоследнийНомерИнтервала = ПроверяемыйНомер;
			Иначе 
				НомерОт 				= ПервыйНомерИнтервала;
				НомерПо 				= СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СтрЗаменить(Строка(ПредыдущийНомер), Символы.НПП, ""), 6, "0", "Слева");				
				//СтруктураИнтервала.Вставить("НомерОт", 				НомерОт);
				//СтруктураИнтервала.Вставить("НомерПо", 				НомерПо);
				//СтруктураИнтервала.Вставить("Серия", 				Серия);
				//СтруктураИнтервала.Вставить("ПервыйИнтервалСерии", 	ПервыйИнтервалСерии);
				//ДобавитьИнтервалЛандшафт(ИнтервалыСерии, СтруктураИнтервала);
				ПредыдущийНомер			= Число(ВыборкаНомера.БланкНомер);
				ПервыйНомерИнтервала	= ВыборкаНомера.БланкНомер;
				ПервыйИнтервалСерии = Ложь;
			КонецЕсли;
		
		КонецЦикла;
		НомерОт = ПервыйНомерИнтервала;
		НомерПо = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СтрЗаменить(Строка(ПредыдущийНомер), Символы.НПП, ""), 6, "0", "Слева");
		//СтруктураИнтервала.Вставить("НомерОт", 				НомерОт);
		//СтруктураИнтервала.Вставить("НомерПо", 				НомерПо);
		//СтруктураИнтервала.Вставить("Серия", 				Серия);
		//СтруктураИнтервала.Вставить("ПервыйИнтервалСерии", 	ПервыйИнтервалСерии);
		//ДобавитьИнтервалЛандшафт(ИнтервалыСерии, СтруктураИнтервала);
		
		СерияСтр = Серия + "-" + ВыборкаСерии.КоличествоВсего;
		//Если Ручные Тогда
		//	Если Формат = Перечисления.ФорматыБланковСФ.А4 Тогда
		//		ИнтервалыСерийА4Р = ИнтервалыСерии;
		//		СерияА4Р = ?(ЗначениеЗаполнено(СерияА4Р), СерияА4Р + ", " + СерияСтр, СерияСтр);
		//	Иначе
		//		ИнтервалыСерийА5Р = ИнтервалыСерии;
		//		СерияА5Р = ?(ЗначениеЗаполнено(СерияА5Р), СерияА5Р + ", " + СерияСтр, СерияСтр);
		//	КонецЕсли;			
		//Иначе
		//	Если Формат = Перечисления.ФорматыБланковСФ.А4 Тогда
		//		ИнтервалыСерийА4П = ИнтервалыСерии;
		//		СерияА4П = ?(ЗначениеЗаполнено(СерияА4П), СерияА4Р + ", " + СерияСтр, СерияСтр);
		//	Иначе
		//		ИнтервалыСерийА5П = ИнтервалыСерии;
		//		СерияА5П = ?(ЗначениеЗаполнено(СерияА5П), СерияА5П + ", " + СерияСтр, СерияСтр);				
		//	КонецЕсли;		
		//КонецЕсли;	
		
	КонецЦикла; // Конец серии
	
	ПараметрыВыборки.Область.Параметры.Всего 		= ОбщееКолво;
	//ПараметрыВыборки.Область.Параметры.СерияА4Р 	= СерияА4Р;
	//ПараметрыВыборки.Область.Параметры.НомераА4Р 	= ИнтервалыСерийА4Р;
	//ПараметрыВыборки.Область.Параметры.СерияА5Р 	= СерияА5Р;
	//ПараметрыВыборки.Область.Параметры.НомераА5Р 	= ИнтервалыСерийА5Р;
	//ПараметрыВыборки.Область.Параметры.СерияА4П 	= СерияА4П;
	//ПараметрыВыборки.Область.Параметры.НомераА4П 	= ИнтервалыСерийА4П;
	//ПараметрыВыборки.Область.Параметры.СерияА5П 	= СерияА5П;
	//ПараметрыВыборки.Область.Параметры.НомераА5П 	= ИнтервалыСерийА5П;	

	ТабличныйДокумент.Вывести(ПараметрыВыборки.Область);
	
КонецПроцедуры

// Процедуры с концовкой "...Подробный" формируют отчет по макету "ПФ_MXL_БланкИспользованныхПодробный"
// 
Процедура СформироватьТабличныйДокументПодробный(СтруктураПараметров, РезультатФормирования) 
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "БланкиСФОтчетОбИспользовании_ОтчетИспользованиеПодробный";
	
	Организация = СтруктураПараметров.Организация;
	НачалоПериода = СтруктураПараметров.НачалоПериода;
	КонецПериода = СтруктураПараметров.КонецПериода;
	
	Макет = ПолучитьМакет("ПФ_MXL_ОтчетИспользованиеПодробный");

	АдресОрганизации	= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Организация, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);

	ОбластьШапка		= Макет.ПолучитьОбласть("Шапка");	
	ОбластьШапкаТаблицы	= Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьГруппы		= Макет.ПолучитьОбласть("Группа");
	ОбластьДетали		= Макет.ПолучитьОбласть("Детали");
	ОбластьПодписи		= Макет.ПолучитьОбласть("Подписи");	
	
	ОбластьШапка.Параметры.НаименованиеОрганизации = Организация.НаименованиеПолное;
	
	ОбластьШапка.Параметры.ИНН 						= Организация.ИНН;
	ОбластьШапка.Параметры.НаименованиеОрганизации 	= Организация.НаименованиеПолное;
	ОбластьШапка.Параметры.Адрес 					= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Организация, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
	
	ТабличныйДокумент.Вывести(ОбластьШапка);
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	Запрос = Новый Запрос;
	Запрос.Текст =		
		"ВЫБРАТЬ
		|	СУММА(БланкиСФОстатки.КоличествоОстаток) КАК КоличествоВсего,
		|	БланкиСФОстатки.Серия КАК Серия,
		|	БланкиСФОстатки.Номер КАК БланкНомер
		|ПОМЕСТИТЬ ОстаткиНачало
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Остатки(&НачалоПериода, Организация = &Организация) КАК БланкиСФОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОстатки.Номер,
		|	БланкиСФОстатки.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БланкиСФОстатки.КоличествоОстаток) КАК КоличествоВсего,
		|	БланкиСФОстатки.Номер КАК БланкНомер,
		|	БланкиСФОстатки.Серия КАК Серия
		|ПОМЕСТИТЬ ОстаткиКонец
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Остатки(&КонецПериода, Организация = &Организация) КАК БланкиСФОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОстатки.Серия,
		|	БланкиСФОстатки.Номер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиНачало.КоличествоВсего КАК КоличествоВсего,
		|	ОстаткиНачало.Серия КАК Серия,
		|	ОстаткиНачало.БланкНомер КАК БланкНомер
		|ИЗ
		|	ОстаткиНачало КАК ОстаткиНачало
		|ГДЕ
		|	ОстаткиНачало.КоличествоВсего > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего)
		|ПО
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиКонец.КоличествоВсего КАК КоличествоВсего,
		|	ОстаткиКонец.БланкНомер КАК БланкНомер,
		|	ОстаткиКонец.Серия КАК Серия
		|ИЗ
		|	ОстаткиКонец КАК ОстаткиКонец
		|ГДЕ
		|	ОстаткиКонец.КоличествоВсего > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего)
		|ПО
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БланкиСФОбороты.КоличествоПриход) КАК КоличествоВсего,
		|	БланкиСФОбороты.Номер КАК БланкНомер,
		|	БланкиСФОбороты.Серия КАК Серия
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.ПриходБланковСФ)) КАК БланкиСФОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОбороты.Номер,
		|	БланкиСФОбороты.Серия
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего)
		|ПО
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БланкиСФОбороты.КоличествоРасход) КАК КоличествоВсего,
		|	БланкиСФОбороты.Номер КАК БланкНомер,
		|	БланкиСФОбороты.Серия КАК Серия
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.ИспользованиеБланковСФ)) КАК БланкиСФОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОбороты.Номер,
		|	БланкиСФОбороты.Серия
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего)
		|ПО
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БланкиСФОбороты.КоличествоРасход) КАК КоличествоВсего,
		|	БланкиСФОбороты.Номер КАК БланкНомер,
		|	БланкиСФОбороты.Серия КАК Серия
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.УтеряБланковСФ)) КАК БланкиСФОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОбороты.Номер,
		|	БланкиСФОбороты.Серия
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего)
		|ПО
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БланкиСФОбороты.КоличествоРасход) КАК КоличествоВсего,
		|	БланкиСФОбороты.Номер КАК БланкНомер,
		|	БланкиСФОбороты.Серия КАК Серия
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.ПорчаБланковСФ)) КАК БланкиСФОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОбороты.Номер,
		|	БланкиСФОбороты.Серия
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего)
		|ПО
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(БланкиСФОбороты.КоличествоРасход) КАК КоличествоВсего,
		|	БланкиСФОбороты.Номер КАК БланкНомер,
		|	БланкиСФОбороты.Серия КАК Серия
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСФ.ПроизводственныйБракБланковСФ)) КАК БланкиСФОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОбороты.Номер,
		|	БланкиСФОбороты.Серия
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	СУММА(КоличествоВсего)
		|ПО
		|	Серия";

	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(НачалоПериода));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(КонецПериода));	
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Запрос.УстановитьПараметр("Организация", Организация);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Организация = &Организация", "Истина");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ПараметрыВыборки = Новый Структура;
	ПараметрыВыборки.Вставить("Пакет", 			РезультатЗапроса[2]);
	ПараметрыВыборки.Вставить("НомерСтроки", 	1);
	ПараметрыВыборки.Вставить("Наименование", 	"Остаток на начало");
	ОбработкаРезультатаЗапросаПодробный(ТабличныйДокумент, Макет, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 			РезультатЗапроса[4]);
	ПараметрыВыборки.Вставить("НомерСтроки", 	2);
	ПараметрыВыборки.Вставить("Наименование", 	"Получено");	
	ОбработкаРезультатаЗапросаПодробный(ТабличныйДокумент, Макет, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 			РезультатЗапроса[5]);
	ПараметрыВыборки.Вставить("НомерСтроки", 	3);
	ПараметрыВыборки.Вставить("Наименование", 	"Использовано");	
	ОбработкаРезультатаЗапросаПодробный(ТабличныйДокумент, Макет, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 			РезультатЗапроса[6]);
	ПараметрыВыборки.Вставить("НомерСтроки", 	4);
	ПараметрыВыборки.Вставить("Наименование", 	"Испорчено");	
	ОбработкаРезультатаЗапросаПодробный(ТабличныйДокумент, Макет, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 			РезультатЗапроса[7]);
	ПараметрыВыборки.Вставить("НомерСтроки", 	5);
	ПараметрыВыборки.Вставить("Наименование", 	"Утеряно");	
	ОбработкаРезультатаЗапросаПодробный(ТабличныйДокумент, Макет, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 			РезультатЗапроса[8]);
	ПараметрыВыборки.Вставить("НомерСтроки", 	6);
	ПараметрыВыборки.Вставить("Наименование", 	"Производственный брак");	
	ОбработкаРезультатаЗапросаПодробный(ТабличныйДокумент, Макет, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 			РезультатЗапроса[3]);
	ПараметрыВыборки.Вставить("НомерСтроки", 	7);
	ПараметрыВыборки.Вставить("Наименование", 	"Остаток на конец");		
	ОбработкаРезультатаЗапросаПодробный(ТабличныйДокумент, Макет, ПараметрыВыборки);
	
	СтруктураРуководство = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Организация, КонецПериода);
	Если НЕ СтруктураРуководство.Свойство("Руководитель") = Неопределено Тогда
		ОбластьПодписи.Параметры.Руководитель 	= СтруктураРуководство.Руководитель;
	КонецЕсли;
	Если НЕ СтруктураРуководство.Свойство("ГлавныйБухгалтер") = Неопределено Тогда
		ОбластьПодписи.Параметры.Главбух 		= СтруктураРуководство.ГлавныйБухгалтер;
	КонецЕсли;
		
	ОбластьПодписи.Параметры.ТелефонОрганизации	= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Организация, Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации);
	ОбластьПодписи.Параметры.Год				= СтрЗаменить(Строка(Год(КонецПериода)), Символы.НПП, "") + " г.";
	
	ТабличныйДокумент.Вывести(ОбластьПодписи);
	
	РезультатФормирования.Результат = ТабличныйДокумент;
	
КонецПроцедуры

Процедура ОбработкаРезультатаЗапросаПодробный(ТабличныйДокумент, Макет, ПараметрыВыборки)
	Пакет 			= ПараметрыВыборки.Пакет;
	ОбластьГруппы 	= Макет.ПолучитьОбласть("Группа");
	ОбластьГруппы.Параметры.Заполнить(ПараметрыВыборки);
	
	ВыборкаГруппы 	= Пакет.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);	
	
	Если ВыборкаГруппы.Количество() = 0 Тогда
		ТабличныйДокумент.Вывести(ОбластьГруппы);
	    Возврат;
	КонецЕсли;
	
	Пока ВыборкаГруппы.Следующий() Цикл	
		ОбластьГруппы.Параметры.Заполнить(ВыборкаГруппы);
		ТабличныйДокумент.Вывести(ОбластьГруппы);

		ВыборкаНомера 			= ВыборкаГруппы.Выбрать();		
		Пока ВыборкаНомера.Следующий() Цикл
			ОбластьДетали 	= Макет.ПолучитьОбласть("Детали");
			ОбластьДетали.Параметры.Заполнить(ВыборкаНомера);
			ОбластьДетали.Параметры.СтрокаНомеров = ВыборкаНомера.Серия + " " + ВыборкаНомера.БланкНомер;
			ТабличныйДокумент.Вывести(ОбластьДетали);			
		КонецЦикла;
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
