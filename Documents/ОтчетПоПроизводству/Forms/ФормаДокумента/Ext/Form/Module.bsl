﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	НеобходимостьПерезаполнения = Ложь;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборЗаказовПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьДанныеИзХранилища(АдресЗапасовВХранилище);
		
		// Установить видимость и доступность элементов формы
		УстановитьВидимостьДоступностьЭлементов();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТабличнаяЧастьГотоваяПродукция

&НаКлиенте
Процедура ГотоваяПродукцияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Элемент.ТекущиеДанные.КлючСвязи = 0 Тогда
		ИмяТабличнойЧасти = "ГотоваяПродукция";
		БухгалтерскийУчетКлиент.ДобавитьКлючСвязиВСтрокуТабличнойЧасти(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ГотоваяПродукцияПередУдалением(Элемент, Отказ)
	ИмяТабличнойЧасти = "ГотоваяПродукция";
	БухгалтерскийУчетКлиент.УдалитьСтрокиПодчиненнойТабличнойЧасти(ЭтотОбъект, "Материалы");
КонецПроцедуры

&НаКлиенте
Процедура ГотоваяПродукцияПослеУдаления(Элемент)	
	
	Если Объект.ГотоваяПродукция.Количество() > 0 Тогда
		НеобходимостьПерезаполнения = Истина;
	Иначе
		НеобходимостьПерезаполнения = Ложь;
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ГотоваяПродукцияКонтрагент.
//
&НаКлиенте
Процедура ГотоваяПродукцияКонтрагентПриИзменении(Элемент)
	НеобходимостьПерезаполнения = Истина;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ГотоваяПродукцияЗаказ.
//
&НаКлиенте
Процедура ГотоваяПродукцияЗаказПриИзменении(Элемент)
	НеобходимостьПерезаполнения = Истина;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ГотоваяПродукцияНоменклатура.
//
&НаКлиенте
Процедура ГотоваяПродукцияНоменклатураПриИзменении(Элемент)
	НеобходимостьПерезаполнения = Истина;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ГотоваяПродукцияВидРаботы.
//
&НаКлиенте
Процедура ГотоваяПродукцияВидРаботыПриИзменении(Элемент)
	НеобходимостьПерезаполнения = Истина;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ГотоваяПродукцияКоличество.
//
&НаКлиенте
Процедура ГотоваяПродукцияКоличествоПриИзменении(Элемент)
	НеобходимостьПерезаполнения = Истина;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ГотоваяПродукцияПолуфабрикаты.
//
&НаКлиенте
Процедура ГотоваяПродукцияПолуфабрикатыПриИзменении(Элемент)
	НеобходимостьПерезаполнения = Истина;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ГотоваяПродукцияСпецификация.
//
&НаКлиенте
Процедура ГотоваяПродукцияСпецификацияПриИзменении(Элемент)
	НеобходимостьПерезаполнения = Истина;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТабличнаяЧастьМатериалы

// Процедура - обработчик события ПриИзменении поля ввода МатериалыНоменклатура.
//
&НаКлиенте
Процедура МатериалыНоменклатураПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Материалы.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Организация", Объект.Организация);
	СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);

	СтрокаТабличнойЧасти.СчетУчета = СтруктураДанные.СчетУчета;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборЗаказов(Команда)
	РаботаСПодборомЗаказовНаПроизводство.ОткрытьПодбор(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМатериалы(Команда)
	Отказ = Ложь;
	
	Если Объект.ГотоваяПродукция.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена табличная часть ""Готовая продукция""! Операция отменена.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ГотоваяПродукция",,Отказ);		
	КонецЕсли;

	Если Отказ Тогда 
		Возврат
	КонецЕсли;		
	
	Если Объект.Материалы.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьПоГотовойПродукции", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные табличной части ""Материалы"" будут перезаполнены! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьМатериалыНаКлиенте();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьПоГотовойПродукции(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьМатериалыНаКлиенте();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.ГруппаСообщенияОНеобходимостиПерезаполненияТЧТовары.Видимость = НеобходимостьПерезаполнения;	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМатериалыНаКлиенте()
	
	ЗаполнитьМатериалыНаСервере();
	НеобходимостьПерезаполнения = Ложь;
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	ТекстОповещения = НСтр("ru = 'Заполнение'");
	ТекстПояснения = НСтр("ru = 'Табличная часть ""Материалы"" заполнена'");
	ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМатериалыНаСервере()

	Объект.Материалы.Очистить(); 
	 
	ТЗГотоваяПродукция = Объект.ГотоваяПродукция.Выгрузить(); 	  
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СпецификацияНоменклатурыМатериалы.Ссылка КАК Ссылка,
		|	СпецификацияНоменклатурыМатериалы.Номенклатура КАК Номенклатура,
		|	СпецификацияНоменклатурыМатериалы.Количество КАК Количество,
		|	СпецификацияНоменклатурыМатериалы.ВидРаботы КАК ВидРаботы
		|ИЗ
		|	Справочник.СпецификацияНоменклатуры.Материалы КАК СпецификацияНоменклатурыМатериалы
		|ГДЕ
		|	СпецификацияНоменклатурыМатериалы.Ссылка В(&Ссылка)";
	Запрос.УстановитьПараметр("Ссылка", ТЗГотоваяПродукция.ВыгрузитьКолонку("Спецификация"));
	ТЗМатериалы = Запрос.Выполнить().Выгрузить();
	ТЗМатериалы.Индексы.Добавить("Ссылка");
	
	Для Каждого СтрокаТаблицыЗначенийГП Из ТЗГотоваяПродукция Цикл				
		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("Ссылка", СтрокаТаблицыЗначенийГП.Спецификация);
		СтруктураОтбора.Вставить("ВидРаботы", СтрокаТаблицыЗначенийГП.ВидРаботы);
		МассивМатериалов = ТЗМатериалы.НайтиСтроки(СтруктураОтбора);
		
		Для Каждого СтрокаМассивМатериалов Из МассивМатериалов Цикл			
			СтрокаТабличнойЧастиМ = Объект.Материалы.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧастиМ, СтрокаТаблицыЗначенийГП);
			СтрокаТабличнойЧастиМ.Продукция = СтрокаТаблицыЗначенийГП.Номенклатура;
			СтрокаТабличнойЧастиМ.Номенклатура = СтрокаМассивМатериалов.Номенклатура;
			СтрокаТабличнойЧастиМ.Количество = СтрокаМассивМатериалов.Количество * СтрокаТаблицыЗначенийГП.Количество;
			// Очищается склад, который выше был заполнен (ЗаполнитьЗначенияСвойств), т.к. материалы могут
			// браться с одного склада, а ГП оприходоваться на другой склад.
			СтрокаТабличнойЧастиМ.Склад = Неопределено;
			
			СтруктураДанных = Новый Структура();
			СтруктураДанных.Вставить("Организация",  Объект.Организация);
			СтруктураДанных.Вставить("Номенклатура", СтрокаМассивМатериалов.Номенклатура);
			ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанных);
			
			СтрокаТабличнойЧастиМ.СчетУчета = СтруктураДанных.СчетУчета;
		КонецЦикла;		
	КонецЦикла;
КонецПроцедуры

// Процедура получает список данные из временного хранилища
//
&НаСервере
Процедура ПолучитьДанныеИзХранилища(АдресЗапасовВХранилище)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	СписокЗначений = Новый СписокЗначений;

	Для каждого СтрокаГП Из Объект.ГотоваяПродукция Цикл
        СписокЗначений.Добавить(СтрокаГП.КлючСвязи);
	КонецЦикла;

    Если СписокЗначений.Количество() = 0 Тогда
		КлючСвязи = 1;
	Иначе
		СписокЗначений.СортироватьПоЗначению();
		КлючСвязи = СписокЗначений.Получить(СписокЗначений.Количество() - 1).Значение + 1;
	КонецЕсли;
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("Контрагент", СтрокаЗагрузки.Контрагент);
		СтруктураОтбора.Вставить("Заказ", СтрокаЗагрузки.Заказ);
		СтруктураОтбора.Вставить("Номенклатура", СтрокаЗагрузки.Номенклатура);
		СтруктураОтбора.Вставить("ВидРаботы", СтрокаЗагрузки.ВидРаботы);

		КоличествоНайденныхСтрок = Объект.ГотоваяПродукция.НайтиСтроки(СтруктураОтбора).Количество();
		
		Если КоличествоНайденныхСтрок = 0 Тогда
			СтрокаТабличнойЧасти = Объект.ГотоваяПродукция.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
			СтрокаТабличнойЧасти.КлючСвязи = КлючСвязи;
			
			НеобходимостьПерезаполнения = Истина;
			
			КлючСвязи = КлючСвязи + 1;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

// Получает набор данных с сервера для процедуры НоменклатураПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	// Счета учета
	СчетаУчетаНоменклатуры = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСчетаУчетаНоменклатуры(СтруктураДанные.Организация, СтруктураДанные.Номенклатура);
	СтруктураДанные.Вставить("СчетУчета", СчетаУчетаНоменклатуры.СчетУчета);
		
	Возврат СтруктураДанные;	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
