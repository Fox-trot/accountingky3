﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Ссылка КАК Регистратор,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	&Содержание КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	""Материалы"" КАК ИмяСписка,
		|	&СинонимСписка КАК СинонимСписка,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаМатериалы.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаМатериалы.СчетУчета КАК СчетУчета,
		|	ВременнаяТаблицаМатериалы.Номенклатура,
		|	ВременнаяТаблицаМатериалы.Склад КАК Склад,
		|	НЕОПРЕДЕЛЕНО КАК ДокументОприходования,
		|	0 КАК Себестоимость,
		|	ВременнаяТаблицаМатериалы.Количество,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаМатериалы.Полуфабрикаты
		|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПроизводствоПолуфабрикатов) 
		|       ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОсновноеПроизводство)
		|   КОНЕЦ КАК КорСчетСписания,
		|	ВременнаяТаблицаМатериалы.Продукция КАК КорСубконто1,
		|	ВременнаяТаблицаМатериалы.Заказ КАК КорСубконто2,
		|	НЕОПРЕДЕЛЕНО КАК КорСубконто3
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаМатериалы КАК ВременнаяТаблицаМатериалы
		|		ПО (ИСТИНА)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("Содержание", НСтр("ru = 'Списание материалов'")); 
	Запрос.УстановитьПараметр("СинонимСписка", НСтр("ru = 'Материалы'"));
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаРеквизиты = МассивРезультатов[0].Выгрузить();
	ТаблицаТовары = МассивРезультатов[1].Выгрузить();
	
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ТаблицаТовары, ТаблицаРеквизиты, Отказ);
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизиты", ТаблицаРеквизиты);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСписанныеТовары", ТаблицаСписанныеТовары);
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьВыполненныеРаботы(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаГотоваяПродукция.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаГотоваяПродукция.Заказ КАК Заказ,
		|	ВременнаяТаблицаГотоваяПродукция.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаГотоваяПродукция.Количество КАК Количество,
		|	ВременнаяТаблицаГотоваяПродукция.Операция КАК Операция,
		|	ВременнаяТаблицаГотоваяПродукция.Спецификация КАК Спецификация,
		|	ВременнаяТаблицаГотоваяПродукция.Склад КАК Склад,
		|	ВременнаяТаблицаГотоваяПродукция.Полуфабрикаты КАК Полуфабрикаты,
		|	ВременнаяТаблицаГотоваяПродукция.Бригада КАК Бригада,
		|	ВременнаяТаблицаГотоваяПродукция.ФИО КАК Исполнитель
		|ИЗ
		|	ВременнаяТаблицаГотоваяПродукция КАК ВременнаяТаблицаГотоваяПродукция
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаВыполненныеРаботы", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка,
		|	ТаблицаДокумента.Дата,
		|	ТаблицаДокумента.Организация
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ОтчетПоПроизводству КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтчетПоПроизводствуГотоваяПродукция.Контрагент,
		|	ОтчетПоПроизводствуГотоваяПродукция.Заказ,
		|	ОтчетПоПроизводствуГотоваяПродукция.Номенклатура,
		|	ОтчетПоПроизводствуГотоваяПродукция.Количество,
		|	ОтчетПоПроизводствуГотоваяПродукция.Операция,
		|	ОтчетПоПроизводствуГотоваяПродукция.Спецификация,
		|	ОтчетПоПроизводствуГотоваяПродукция.Склад,
		|	ОтчетПоПроизводствуГотоваяПродукция.Полуфабрикаты,
		|	ОтчетПоПроизводствуГотоваяПродукция.Бригада,
		|	ОтчетПоПроизводствуГотоваяПродукция.ФИО
		|ПОМЕСТИТЬ ВременнаяТаблицаГотоваяПродукция
		|ИЗ
		|	Документ.ОтчетПоПроизводству.ГотоваяПродукция КАК ОтчетПоПроизводствуГотоваяПродукция
		|ГДЕ
		|	ОтчетПоПроизводствуГотоваяПродукция.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтчетПоПроизводствуМатериалы.Заказ,
		|	ОтчетПоПроизводствуМатериалы.НомерСтроки,
		|	ОтчетПоПроизводствуМатериалы.Продукция,
		|	ОтчетПоПроизводствуМатериалы.Номенклатура,
		|	ОтчетПоПроизводствуМатериалы.СчетУчета,
		|	ОтчетПоПроизводствуМатериалы.Склад,
		|	ОтчетПоПроизводствуМатериалы.Количество,
		|	ОтчетПоПроизводствуМатериалы.Полуфабрикаты
		|ПОМЕСТИТЬ ВременнаяТаблицаМатериалы
		|ИЗ
		|	Документ.ОтчетПоПроизводству.Материалы КАК ОтчетПоПроизводствуМатериалы
		|ГДЕ
		|	ОтчетПоПроизводствуМатериалы.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьВыполненныеРаботы(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Процедура определяет готовые заказы и если таковые имеются
// то подготавливает данные для проводок.
Процедура СформироватьТаблицуГотовыхЗаказов(ДополнительныеСвойства) Экспорт

	ГраницаКонтроля = Новый Граница(ДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая);
	Ссылка = ДополнительныеСвойства.ДляПроведения.Ссылка;
	Дата = ДополнительныеСвойства.ДляПроведения.Дата;
	Организация = ДополнительныеСвойства.ДляПроведения.Организация;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаГотоваяПродукция.Заказ,
		|	ТаблицаГотоваяПродукция.Номенклатура,
		|	ТаблицаГотоваяПродукция.Операция,
		|	ТаблицаГотоваяПродукция.Спецификация,
		|	ТаблицаГотоваяПродукция.Полуфабрикаты
		|ПОМЕСТИТЬ ВременнаяТаблицаЗаказы
		|ИЗ
		|	&ТаблицаГотоваяПродукция КАК ТаблицаГотоваяПродукция";	
	Запрос.УстановитьПараметр("ТаблицаГотоваяПродукция", Ссылка.ГотоваяПродукция);
	Запрос.Выполнить();
	  
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
	    "ВЫБРАТЬ
	    |	ВременнаяТаблицаЗаказы.Заказ КАК Заказ,
	    |	ВременнаяТаблицаЗаказы.Номенклатура КАК Номенклатура,
	    |	ВременнаяТаблицаЗаказы.Спецификация КАК Спецификация
		|ПОМЕСТИТЬ ВременнаяТаблицаВыполненныеРаботы
	    |ИЗ
	    |	ВременнаяТаблицаЗаказы КАК ВременнаяТаблицаЗаказы
	    |
	    |ОБЪЕДИНИТЬ
	    |
	    |ВЫБРАТЬ
	    |	ВыполненныеРаботыСрезПоследних.Заказ,
	    |	ВыполненныеРаботыСрезПоследних.Номенклатура,
	    |	ВыполненныеРаботыСрезПоследних.Спецификация
	    |ИЗ
	    |	РегистрСведений.ВыполненныеРаботы.СрезПоследних(
	    |			&Период,
	    |			Организация = &Организация
	    |				И Заказ В
	    |					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	    |						ВременнаяТаблицаЗаказы.Заказ
	    |					ИЗ
	    |						ВременнаяТаблицаЗаказы)) КАК ВыполненныеРаботыСрезПоследних
		|;
		|
		|/////////////////////////////////////////////////////////////////////////////////////////
	    |ВЫБРАТЬ
	    |	ЗаказаннаяПродукцияСрезПоследних.Заказ КАК Заказ,
	    |	ЗаказаннаяПродукцияСрезПоследних.Номенклатура КАК Номенклатура,
	    |	ВременнаяТаблицаВыполненныеРаботы.Спецификация КАК Спецификация
		|ПОМЕСТИТЬ ВременнаяТаблицаПродукцияВРаботе
	    |ИЗ
	    |	РегистрСведений.ЗаказаннаяПродукция.СрезПоследних(
	    |			&Период,
	    |			Организация = &Организация
	    |				И Заказ В
	    |					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	    |						ВременнаяТаблицаВыполненныеРаботы.Заказ
	    |					ИЗ
	    |						ВременнаяТаблицаВыполненныеРаботы)) КАК ЗаказаннаяПродукцияСрезПоследних
	    |		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаВыполненныеРаботы КАК ВременнаяТаблицаВыполненныеРаботы
	    |		ПО ЗаказаннаяПродукцияСрезПоследних.Заказ = ВременнаяТаблицаВыполненныеРаботы.Заказ
	    |			И ЗаказаннаяПродукцияСрезПоследних.Номенклатура = ВременнаяТаблицаВыполненныеРаботы.Номенклатура
		|;
		|
		|/////////////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаПродукцияВРаботе.Заказ
		|ИЗ
		|	ВременнаяТаблицаПродукцияВРаботе КАК ВременнаяТаблицаПродукцияВРаботе
		|ГДЕ
		|	ВременнаяТаблицаПродукцияВРаботе.Спецификация ЕСТЬ NULL";
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Если Запрос.Выполнить().Пустой() Тогда	
		Запрос = Новый Запрос();
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Текст =	
			"ВЫБРАТЬ
			|   	ВременнаяТаблицаЗаказы.Заказ,
			|   	ВременнаяТаблицаЗаказы.Номенклатура,
			|   	СпецификацияНоменклатурыОперации.Операция,
			|   	ВременнаяТаблицаЗаказы.Спецификация,
			|   	ВременнаяТаблицаЗаказы.Полуфабрикаты
			|ПОМЕСТИТЬ ВременнаяТаблицаОперации
			|ИЗ
			|	ВременнаяТаблицаЗаказы КАК ВременнаяТаблицаЗаказы
			|	ПОЛНОЕ СОЕДИНЕНИЕ Справочник.СпецификацииНоменклатуры.Операции КАК СпецификацияНоменклатурыОперации
			|	ПО ВременнаяТаблицаЗаказы.Спецификация = СпецификацияНоменклатурыОперации.Ссылка
			|;
			|
			|///////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВременнаяТаблицаОперации.Заказ,
			|   ВременнаяТаблицаОперации.Номенклатура,
			|   ВременнаяТаблицаОперации.Операция,
			|   ВременнаяТаблицаОперации.Спецификация,
			|   ВременнаяТаблицаОперации.Полуфабрикаты,
			|	ВыполненныеРаботыСрезПоследних.Исполнитель
			|ПОМЕСТИТЬ ВременнаяТаблицаСостоянийРабот
			|ИЗ
			|	ВременнаяТаблицаОперации КАК ВременнаяТаблицаОперации
			|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВыполненныеРаботы.СрезПоследних(
			|			&Период, 
			|			Организация = &Организация 
			|				И Заказ В (ВЫБРАТЬ РАЗЛИЧНЫЕ
			|								ВременнаяТаблицаЗаказы.Заказ
			|							ИЗ
			|								ВременнаяТаблицаЗаказы КАК ВременнаяТаблицаЗаказы)) КАК ВыполненныеРаботыСрезПоследних
			|	ПО ВременнаяТаблицаОперации.Заказ = ВыполненныеРаботыСрезПоследних.Заказ
			|	И ВременнаяТаблицаОперации.Номенклатура = ВыполненныеРаботыСрезПоследних.Номенклатура
			|	И ВременнаяТаблицаОперации.Операция = ВыполненныеРаботыСрезПоследних.Операция
			|	И ВременнаяТаблицаОперации.Спецификация = ВыполненныеРаботыСрезПоследних.Спецификация
			|ГДЕ
			|	НЕ ВременнаяТаблицаОперации.Заказ ЕСТЬ NULL
			|;
			|
			|///////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВременнаяТаблицаСостоянийРабот.Заказ,
			|   ВременнаяТаблицаСостоянийРабот.Номенклатура,
			|   ВременнаяТаблицаСостоянийРабот.Операция,
			|   ВременнаяТаблицаСостоянийРабот.Спецификация,
			|   ВременнаяТаблицаСостоянийРабот.Полуфабрикаты,
			|	ЕСТЬNULL(ВременнаяТаблицаСостоянийРабот.Исполнитель, """") КАК Исполнитель
			|ИЗ
			|	ВременнаяТаблицаСостоянийРабот КАК ВременнаяТаблицаСостоянийРабот
			|
			|ИТОГИ
			|	МАКСИМУМ(Номенклатура),
			|   МАКСИМУМ(Операция),
			|   МАКСИМУМ(Спецификация),
			|   МАКСИМУМ(Полуфабрикаты),
			|   МАКСИМУМ(Исполнитель)
			|ПО
			|	Заказ";
		Запрос.УстановитьПараметр("Период", ГраницаКонтроля);
		Запрос.УстановитьПараметр("Организация", Организация);
		ВыборкаПоГруппировкам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		МассивГотовыхЗаказовГП = Новый Массив(); // Готовая продукция
		МассивГотовыхЗаказовПФ = Новый Массив(); // Полуфабрикаты
		
		Пока ВыборкаПоГруппировкам.Следующий() Цикл
			
			ЗаказГотов = Ложь;
			
			ДетальныеЗаписи = ВыборкаПоГруппировкам.Выбрать();
			
			Пока ДетальныеЗаписи.Следующий() Цикл
				Если ДетальныеЗаписи.Исполнитель <> "" Тогда
					ЗаказГотов = Истина;
					ЗаказПолуфабрикатов = ДетальныеЗаписи.Полуфабрикаты;
				Иначе
					ЗаказГотов = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;	
			
			Если ЗаказГотов Тогда
				Если ЗаказПолуфабрикатов Тогда
					МассивГотовыхЗаказовПФ.Добавить(ВыборкаПоГруппировкам.Заказ);
				Иначе	
					МассивГотовыхЗаказовГП.Добавить(ВыборкаПоГруппировкам.Заказ);	
				КонецЕсли;			
			КонецЕсли;	
		КонецЦикла;
		
		Если МассивГотовыхЗаказовГП.Количество() > 0 ИЛИ МассивГотовыхЗаказовПФ.Количество() > 0 Тогда
			
			Если МассивГотовыхЗаказовГП.Количество() > 0 Тогда
				МассивПродукцииГП = ПолучитьМассивСубконтоНоменклатура(МассивГотовыхЗаказовГП, ГраницаКонтроля, Организация);
			КонецЕсли;
			
			Если МассивГотовыхЗаказовПФ.Количество() > 0 Тогда
				МассивПродукцииПФ = ПолучитьМассивСубконтоНоменклатура(МассивГотовыхЗаказовПФ, ГраницаКонтроля, Организация);
			КонецЕсли;
			
			Запрос = Новый Запрос();
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ХозрасчетныйОстатки.Субконто1 КАК Номенклатура,
				|	ХозрасчетныйОстатки.Субконто2 КАК Заказ,
				|	ХозрасчетныйОстатки.СуммаОстатокДт КАК Сумма
				|ПОМЕСТИТЬ ВременнаяТаблицаХозрасчетныйОстатки
				|ИЗ
				|	РегистрБухгалтерии.Хозрасчетный.Остатки(
				|			&Период,
				|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОсновноеПроизводство),
				|			&ВидыСубконто,
				|			Организация = &Организация
				|				И Субконто1 В (&МассивПродукцииГП)
				|				И Субконто2 В (&МассивГотовыхЗаказовГП)) КАК ХозрасчетныйОстатки
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ХозрасчетныйОстатки.Субконто1,
				|	ХозрасчетныйОстатки.Субконто2,
				|	ХозрасчетныйОстатки.СуммаОстатокДт
				|ИЗ
				|	РегистрБухгалтерии.Хозрасчетный.Остатки(
				|			&Период,
				|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПроизводствоПолуфабрикатов),
				|			&ВидыСубконто,
				|			Организация = &Организация
				|				И Субконто1 В (&МассивПродукцииПФ)
				|				И Субконто2 В (&МассивГотовыхЗаказовПФ)) КАК ХозрасчетныйОстатки
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ВыполненныеРаботыСрезПоследних.Количество КАК Количество,
				|	ВыполненныеРаботыСрезПоследних.Склад КАК Склад,
				|	ВыполненныеРаботыСрезПоследних.Номенклатура КАК Номенклатура,
				|	ВыполненныеРаботыСрезПоследних.Заказ КАК Заказ,
				|	ВыполненныеРаботыСрезПоследних.Полуфабрикаты КАК Полуфабрикаты
				|ПОМЕСТИТЬ ВременнаяТаблицаСостояниеЗаказов
				|ИЗ
				|	РегистрСведений.ВыполненныеРаботы.СрезПоследних(
				|			&Период,
				|			Организация = &Организация
				|			И Заказ В (&МассивГотовыхЗаказовГП)) КАК ВыполненныеРаботыСрезПоследних
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ВыполненныеРаботыСрезПоследних.Количество,
				|	ВыполненныеРаботыСрезПоследних.Склад,
				|	ВыполненныеРаботыСрезПоследних.Номенклатура,
				|	ВыполненныеРаботыСрезПоследних.Заказ,
				|	ВыполненныеРаботыСрезПоследних.Полуфабрикаты
				|ИЗ
				|	РегистрСведений.ВыполненныеРаботы.СрезПоследних(
				|			&Период,
				|			Организация = &Организация
				|			И Заказ В (&МассивГотовыхЗаказовПФ)) КАК ВыполненныеРаботыСрезПоследних
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|   ВЫБОР
				|   	КОГДА ВременнаяТаблицаСостояниеЗаказов.Полуфабрикаты
				|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ЗапасыСырьяИМатериалов)
				|       ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ГотоваяПродукция)
				|   КОНЕЦ КАК СчетУчета, 
				|	ВременнаяТаблицаХозрасчетныйОстатки.Номенклатура КАК Номенклатура,
				|	ВременнаяТаблицаСостояниеЗаказов.Склад КАК Склад,
				|	ВременнаяТаблицаХозрасчетныйОстатки.Заказ КАК Заказ,
				|	ВременнаяТаблицаХозрасчетныйОстатки.Сумма КАК Сумма,
				|	ВременнаяТаблицаСостояниеЗаказов.Количество КАК Количество,
				|	ВЫБОР
				|   	КОГДА ВременнаяТаблицаСостояниеЗаказов.Полуфабрикаты
				|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПроизводствоПолуфабрикатов)
				|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОсновноеПроизводство)
				|   КОНЕЦ КАК КорСчет,
				|	ВременнаяТаблицаХозрасчетныйОстатки.Номенклатура КАК КорСубконто1,
				|	ВременнаяТаблицаХозрасчетныйОстатки.Заказ КАК КорСубконто2,
				|	НЕОПРЕДЕЛЕНО КАК КорСубконто3
				|ИЗ
				|	ВременнаяТаблицаХозрасчетныйОстатки КАК ВременнаяТаблицаХозрасчетныйОстатки
				|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаСостояниеЗаказов КАК ВременнаяТаблицаСостояниеЗаказов
				|		ПО ВременнаяТаблицаХозрасчетныйОстатки.Заказ = ВременнаяТаблицаСостояниеЗаказов.Заказ
				|			И ВременнаяТаблицаХозрасчетныйОстатки.Номенклатура = ВременнаяТаблицаСостояниеЗаказов.Номенклатура";
			ВидыСубконто = Новый Массив;
			ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);	
			ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии);
			
			Запрос.УстановитьПараметр("Период", 			    ГраницаКонтроля);
			Запрос.УстановитьПараметр("Дата", 				    Дата);
			Запрос.УстановитьПараметр("ВидыСубконто",		    ВидыСубконто);
			Запрос.УстановитьПараметр("Организация", 		    Организация);          
			Запрос.УстановитьПараметр("МассивПродукцииГП", 	    МассивПродукцииГП);
			Запрос.УстановитьПараметр("МассивПродукцииПФ", 	    МассивПродукцииПФ);
			Запрос.УстановитьПараметр("МассивГотовыхЗаказовГП", МассивГотовыхЗаказовГП);
			Запрос.УстановитьПараметр("МассивГотовыхЗаказовПФ", МассивГотовыхЗаказовПФ);
			  				
			ТаблицаРеквизиты = Новый ТаблицаЗначений;
			ТаблицаРеквизиты.Колонки.Добавить("Регистратор", Новый ОписаниеТипов("ДокументСсылка.ОтчетПоПроизводству"), "Регистратор");
			ТаблицаРеквизиты.Колонки.Добавить("Период", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата), "Период");
			ТаблицаРеквизиты.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"), "Организация");
			ТаблицаРеквизиты.Колонки.Добавить("Содержание", ОбщегоНазначения.ОписаниеТипаСтрока(30), "Содержание");
			
			СтрокаТаблицыЗначений = ТаблицаРеквизиты.Добавить();
			СтрокаТаблицыЗначений.Регистратор = Ссылка;
			СтрокаТаблицыЗначений.Период = Дата;
			СтрокаТаблицыЗначений.Организация = Организация;
			СтрокаТаблицыЗначений.Содержание = НСтр("ru = 'Выпуск готовой продукции'");
			
			Результат = Запрос.Выполнить();
			
			ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизитыГП", ТаблицаРеквизиты);
			ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаГотоваяПродукция", Результат.Выгрузить());
			
			// Формирование данных для РС "СостояниеЗаказов".
			ТаблицаСостояниеЗаказов = Новый ТаблицаЗначений();
			ТаблицаСостояниеЗаказов.Колонки.Добавить("Период");
			ТаблицаСостояниеЗаказов.Колонки.Добавить("Организация");
			ТаблицаСостояниеЗаказов.Колонки.Добавить("Заказ");
			ТаблицаСостояниеЗаказов.Колонки.Добавить("Состояние");
			
			Если МассивГотовыхЗаказовГП.Количество() > 0 Тогда
				Для Каждого СтрокаМассива Из МассивГотовыхЗаказовГП Цикл
					СтрокаТаблицы = ТаблицаСостояниеЗаказов.Добавить();
					СтрокаТаблицы.Период = Дата;
					СтрокаТаблицы.Организация = Организация;
					СтрокаТаблицы.Заказ = СтрокаМассива;
					СтрокаТаблицы.Состояние = Перечисления.СостоянияЗаказовПоПроизводству.Изготовлен;
				КонецЦикла;	
			КонецЕсли;
			
			Если МассивГотовыхЗаказовПФ.Количество() > 0 Тогда
				Для Каждого СтрокаМассива Из МассивГотовыхЗаказовПФ Цикл
					СтрокаТаблицы = ТаблицаСостояниеЗаказов.Добавить();
					СтрокаТаблицы.Период = Дата;
					СтрокаТаблицы.Организация = Организация;
					СтрокаТаблицы.Заказ = СтрокаМассива;;
					СтрокаТаблицы.Состояние = Перечисления.СостоянияЗаказовПоПроизводству.Изготовлен;
				КонецЦикла;	
			КонецЕсли;
			
			ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСостояниеЗаказов", ТаблицаСостояниеЗаказов);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Функция получает номенклатура и сохраняет ее в массив.
//
// Параметры:
//	МассивГотовыхЗаказов - массив - массив ссылок на документы "Заказ на производство".
//	ГраницаКонтроля - граница - граница контроля.
//
// Возвращаемое значение:
//  Массив - массив готовой продукции по заказам.
// 
Функция ПолучитьМассивСубконтоНоменклатура(МассивГотовыхЗаказов, ГраницаКонтроля, Организация)

	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВыполненныеРаботыСрезПоследних.Номенклатура КАК Номенклатура
		|ИЗ
		|	РегистрСведений.ВыполненныеРаботы.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|			И Заказ В (&МассивГотовыхЗаказов)) КАК ВыполненныеРаботыСрезПоследних";
	Запрос.УстановитьПараметр("Период", ГраницаКонтроля);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("МассивГотовыхЗаказов", МассивГотовыхЗаказов);	
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Номенклатура")
КонецФункции // ПолучитьМассивСубконтоНоменклатура()

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

#КонецЕсли
