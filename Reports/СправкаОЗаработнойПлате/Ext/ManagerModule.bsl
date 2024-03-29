﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет
//   поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "");
	НастройкиВарианта.Описание = НСтр("ru = 'Справка о заработной плате.'");
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Справка'");
КонецПроцедуры

// Для формирования отчета в фоновом задании.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  АдресХранилища - Строка - адрес временного хранилища, куда будет помещен результат формирования отчета.
//
Процедура СформироватьОтчет(Знач ПараметрыОтчета, АдресХранилища) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	// Присвоим имя для сохранения параметров печати табличного документа.
	ТабличныйДокумент.ИмяПараметровПечати = "СправкаОЗаработнойПлате";
	ТабличныйДокумент.АвтоМасштаб = Истина;

	// Спислк видов удержаний для данного отчета определяется оформленными документами Исполнительнй лист за весь период.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПлановыеУдержанияНачалоСрезПоследних.ВидРасчета КАК ВидРасчета
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияНачало.СрезПоследних(, Регистратор ССЫЛКА Документ.ИсполнительныйЛист) КАК ПлановыеУдержанияНачалоСрезПоследних";
	СписокВидовУдержанийИсполнительногоЛиста = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидРасчета");
	
	// Выполним общий запрос.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизЛицо КАК ФизЛицо,
		|	СотрудникиСрезПоследних.Должность.Наименование КАК ДолжностьНаименование,
		|	СотрудникиСрезПоследних.ФизЛицо.Наименование КАК ФизЛицоНаименование,
		|	СотрудникиСрезПоследних.Организация КАК Организация,
		|	СотрудникиСрезПоследних.Подразделение.Наименование КАК ПодразделениеНаименование,
		|	СотрудникиСрезПоследних.ФизЛицо.ИНН КАК ФизЛицоИНН,
		|	СотрудникиСрезПоследних.ФизЛицо.Код КАК ФизЛицоКод
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&КонецПериода,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо) КАК СотрудникиСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Начисления.ПериодРегистрации КАК ПериодРегистрации,
		|	Начисления.ФизЛицо КАК ФизЛицо,
		|	ВЫБОР
		|		КОГДА Начисления.ВидРасчета.ДополнительныйДоход
		|			ТОГДА 0
		|		ИНАЧЕ Начисления.Результат
		|	КОНЕЦ КАК СуммаНачислено,
		|	0 КАК СуммаУдержано,
		|	0 КАК СуммаСФ,
		|	0 КАК СуммаПН,
		|	0 КАК СуммаПрофВзнос
		|ПОМЕСТИТЬ ВременнаяТаблицаЗаработнаяПлата
		|ИЗ
		|	РегистрРасчета.Начисления КАК Начисления
		|ГДЕ
		|	Начисления.ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода
		|	И Начисления.Организация = &Организация
		|	И Начисления.ФизЛицо = &ФизЛицо
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Удержания.ПериодРегистрации,
		|	Удержания.ФизЛицо,
		|	0,
		|	Удержания.Результат,
		|	0,
		|	0,
		|	0
		|ИЗ
		|	РегистрРасчета.Удержания КАК Удержания
		|ГДЕ
		|	Удержания.ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода
		|	И Удержания.Организация = &Организация
		|	И Удержания.ФизЛицо = &ФизЛицо
		|	И Удержания.ВидРасчета В(&СписокВидовУдержанийИсполнительногоЛиста)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НалогиПоЗаработнойПлатеОбороты.ПериодМесяц,
		|	НалогиПоЗаработнойПлатеОбороты.ФизЛицо,
		|	0,
		|	0,
		|	ВЫБОР
		|		КОГДА НалогиПоЗаработнойПлатеОбороты.ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПФР)
		|			ТОГДА НалогиПоЗаработнойПлатеОбороты.СуммаОборот
		|		КОГДА НалогиПоЗаработнойПлатеОбороты.ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ГНПФР)
		|			ТОГДА НалогиПоЗаработнойПлатеОбороты.СуммаОборот
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА НалогиПоЗаработнойПлатеОбороты.ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПН)
		|			ТОГДА НалогиПоЗаработнойПлатеОбороты.СуммаОборот
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА НалогиПоЗаработнойПлатеОбороты.ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПрофВзнос)
		|			ТОГДА НалогиПоЗаработнойПлатеОбороты.СуммаОборот
		|		ИНАЧЕ 0
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо) КАК НалогиПоЗаработнойПлатеОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаЗаработнаяПлата.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаЗаработнаяПлата.ПериодРегистрации КАК ПериодРегистрации,
		|	СУММА(ВременнаяТаблицаЗаработнаяПлата.СуммаНачислено) КАК СуммаНачислено,
		|	СУММА(ВременнаяТаблицаЗаработнаяПлата.СуммаУдержано) КАК СуммаУдержано,
		|	СУММА(ВременнаяТаблицаЗаработнаяПлата.СуммаСФ) КАК СуммаСФ,
		|	СУММА(ВременнаяТаблицаЗаработнаяПлата.СуммаПН) КАК СуммаПН,
		|	СУММА(ВременнаяТаблицаЗаработнаяПлата.СуммаПрофВзнос) КАК СуммаПрофВзнос,
		|	СУММА(ВременнаяТаблицаЗаработнаяПлата.СуммаНачислено - ВременнаяТаблицаЗаработнаяПлата.СуммаУдержано - ВременнаяТаблицаЗаработнаяПлата.СуммаСФ - ВременнаяТаблицаЗаработнаяПлата.СуммаПН - ВременнаяТаблицаЗаработнаяПлата.СуммаПрофВзнос) КАК СуммаКВыплате
		|ИЗ
		|	ВременнаяТаблицаЗаработнаяПлата КАК ВременнаяТаблицаЗаработнаяПлата
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаЗаработнаяПлата.ПериодРегистрации,
		|	ВременнаяТаблицаЗаработнаяПлата.ФизЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПериодРегистрации
		|ИТОГИ
		|	СУММА(СуммаНачислено),
		|	СУММА(СуммаУдержано),
		|	СУММА(СуммаСФ),
		|	СУММА(СуммаПН),
		|	СУММА(СуммаПрофВзнос),
		|	СУММА(СуммаКВыплате)
		|ПО
		|	ОБЩИЕ";
	Запрос.УстановитьПараметр("НачалоПериода", ПараметрыОтчета.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	Запрос.УстановитьПараметр("Организация", ПараметрыОтчета.Организация);
	Запрос.УстановитьПараметр("ФизЛицо", ПараметрыОтчета.ФизЛицо);
	Запрос.УстановитьПараметр("СписокВидовУдержанийИсполнительногоЛиста", СписокВидовУдержанийИсполнительногоЛиста);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Если МассивРезультатов[0].Пустой() Тогда 
		Возврат;
	КонецЕсли;	
	
	ВыборкаСотрудники = МассивРезультатов[0].Выбрать();
	ВыборкаСотрудники.Следующий();
	
	Если ПараметрыОтчета.ФормаОтчета = 0 Тогда  
		Макет = ПолучитьМакет("СправкаОЗаработнойПлатеПолная");
	Иначе 
		Макет = ПолучитьМакет("СправкаОЗаработнойПлатеУпрощенная");
	КонецЕсли;	

	// Вывод отчета.
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ОбластьЗаголовок.Параметры.Заполнить(ВыборкаСотрудники);
	
	ОбластьЗаголовок.Параметры.НачалоПериода = Формат(ПараметрыОтчета.НачалоПериода, "ДЛФ=D");
	ОбластьЗаголовок.Параметры.КонецПериода = Формат(ПараметрыОтчета.КонецПериода, "ДЛФ=D");
	
	СведенияОбОрганизации = БухгалтерскийУчетСервер.ПолучитьСведенияОбОрганизации(ВыборкаСотрудники.Организация);
	
	ОбластьЗаголовок.Параметры.ОрганизацияНаименованиеПолное = СведенияОбОрганизации.НаименованиеПолное;
	ОбластьЗаголовок.Параметры.Адрес = СведенияОбОрганизации.АдрЮР + "; " + СведенияОбОрганизации.Тел;
	ОбластьЗаголовок.Параметры.ИНН = СведенияОбОрганизации.ИНН;
	ОбластьЗаголовок.Параметры.ТекущаяДата = ТекущаяДатаСеанса();
	
	ОбластьЗаголовок.Параметры.ФизЛицоНаименование = ВыборкаСотрудники.ФизЛицоНаименование +
		?(ВыборкаСотрудники.ФизЛицоКод <> "", ", " + ВыборкаСотрудники.ФизЛицоКод, "") +
		?(ВыборкаСотрудники.ФизЛицоИНН <> "", ", " + ВыборкаСотрудники.ФизЛицоИНН, "");
	
	ТабличныйДокумент.Вывести(ОбластьЗаголовок);
	
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);

	ВыборкаИтоги = МассивРезультатов[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если ВыборкаИтоги.Следующий() Тогда 
		ВыборкаДетали = ВыборкаИтоги.Выбрать();
		Пока ВыборкаДетали.Следующий() Цикл  
			ОбластьСтрока.Параметры.Заполнить(ВыборкаДетали);
			ТабличныйДокумент.Вывести(ОбластьСтрока);
		КонецЦикла;
		
		ОбластьПодвал.Параметры.Заполнить(ВыборкаИтоги);
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		Если ПараметрыОтчета.ФормаОтчета = 0 Тогда  
			ОбластьСуммаПрописью = Макет.ПолучитьОбласть("СуммаПрописью");

			СуммаПрописью = БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ВыборкаИтоги.СуммаКВыплате);
			ОбластьСуммаПрописью.Параметры.СуммаПрописью = СуммаПрописью;
			ТабличныйДокумент.Вывести(ОбластьСуммаПрописью);
		КонецЕсли;
	КонецЕсли;	
		
	// Вывод подписей
	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, ТабличныйДокумент);
	
	// Отчет выведен.
	
	УправлениеКолонтитулами.УстановитьКолонтитулы(ТабличныйДокумент, НСтр("ru = 'Справка о заработной плате'"));
	
	ПоместитьВоВременноеХранилище(ТабличныйДокумент, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли