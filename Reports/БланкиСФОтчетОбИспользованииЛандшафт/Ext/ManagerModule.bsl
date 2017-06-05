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
	НастройкиВарианта.Описание = НСтр("ru = 'Общий отчет об использование бланков счет-фактур НДС с сериями и номерами.'");

	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
		НСтр("ru = 'ИНН облагаемого субъекта
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
		|Дата подачи ОТЧЕТА'");
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов =
		НСтр("ru = 'НачалоПериода
		|КонецПериода
		|Организация'");
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Общий отчет об использование бланков счет-фактур НДС с сериями и номерами'");
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
	СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования);
	ПоместитьВоВременноеХранилище(РезультатФормирования, АдресХранилища);
	
КонецПроцедуры

Процедура СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования) 
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "БланкиСФОтчетОбИспользованииЛандшафт_БланкИспользованныхЛандшафт";
	
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
	ОбработкаРезультатаЗапроса(ТабличныйДокумент, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[4]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьПолучено);
	ОбработкаРезультатаЗапроса(ТабличныйДокумент, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[5]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьИспользовано);
	ОбработкаРезультатаЗапроса(ТабличныйДокумент, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[6]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьУтеряно);
	ОбработкаРезультатаЗапроса(ТабличныйДокумент, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[7]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьИспорчено);
	ОбработкаРезультатаЗапроса(ТабличныйДокумент, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[8]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьПроизводственныйБрак);
	ОбработкаРезультатаЗапроса(ТабличныйДокумент, ПараметрыВыборки);
	
	ПараметрыВыборки.Вставить("Пакет", 		РезультатЗапроса[3]);
	ПараметрыВыборки.Вставить("Область", 	ОбластьОстатокКонец);	
	ОбработкаРезультатаЗапроса(ТабличныйДокумент, ПараметрыВыборки);	
	
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
	РезультатФормирования.Результат = ТабличныйДокумент;
	
КонецПроцедуры

Процедура ОбработкаРезультатаЗапроса(ТабличныйДокумент, ПараметрыВыборки)
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
		//ИнтервалыСерии 			= ПолучитьНужныйИнтервалСерий(ПараметрыИнтервалов);
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
				//ДобавитьИнтервал(ИнтервалыСерии, СтруктураИнтервала);
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
		//ДобавитьИнтервал(ИнтервалыСерии, СтруктураИнтервала);
		
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

//Процедура ДобавитьИнтервал(ИнтервалыСерии, СтруктураИнтервала)
//	НомерОт 			= СтруктураИнтервала.НомерОт;
//	НомерПо 			= СтруктураИнтервала.НомерПо;
//	Серия 				= СтруктураИнтервала.Серия;
//	ПервыйИнтервалСерии = СтруктураИнтервала.ПервыйИнтервалСерии;
//	СерияСтр = ?(ПервыйИнтервалСерии, Серия + ": ", "");
//	Если НомерОт = НомерПо Тогда
//		ИнтервалыСерии = ?(ЗначениеЗаполнено(ИнтервалыСерии), ИнтервалыСерии + ", " + СерияСтр + НомерОт, СерияСтр + НомерОт);
//	Иначе
//		ИнтервалыСерии = ?(ЗначениеЗаполнено(ИнтервалыСерии), ИнтервалыСерии + ", " + СерияСтр + НомерОт + "-" + НомерПо, СерияСтр + НомерОт + "-" + НомерПо);
//	КонецЕсли; 
//	
//КонецПроцедуры

//Функция ПолучитьНужныйИнтервалСерий(ПараметрыИнтервалов)
//	
//	Если ПараметрыИнтервалов.Ручные Тогда
//		Если ПараметрыИнтервалов.Формат = Перечисления.ФорматыБланковСФ.А4 Тогда
//			Возврат ПараметрыИнтервалов.ИнтервалыСерийА4Р;
//		Иначе
//			Возврат ПараметрыИнтервалов.ИнтервалыСерийА5Р;
//		КонецЕсли;			
//	Иначе
//		Если ПараметрыИнтервалов.Формат = Перечисления.ФорматыБланковСФ.А4 Тогда
//			Возврат ПараметрыИнтервалов.ИнтервалыСерийА4П;
//		Иначе
//			Возврат ПараметрыИнтервалов.ИнтервалыСерийА5П;
//		КонецЕсли;		
//	КонецЕсли;	

//КонецФункции // ПолучитьИнтервалыСерий(Серия, Формат)

#КонецОбласти

#КонецЕсли
