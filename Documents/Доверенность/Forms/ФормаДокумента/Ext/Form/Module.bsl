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
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();	
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(ЭтаФорма, "ДокументыФизическихЛиц", Объект.ФизЛицо);
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
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
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МенеджерЗаписи = РегистрыСведений.ДокументыФизическихЛиц.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Прочитать();	
	ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность = Истина;
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДокументыФизическихЛиц);
	МенеджерЗаписи.Физлицо = ТекущийОбъект.ФизЛицо;
		
	Попытка
		МенеджерЗаписи.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборНоменклатурыПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьТоварыИзХранилища(АдресЗапасовВХранилище);
		Для Каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл
			Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) И ТипЗнч(СтрокаТабличнойЧасти.Номенклатура) = ТИП("СправочникСсылка.Номенклатура") Тогда
				СтрокаТабличнойЧасти.ЕдиницаИзмерения = ЕдиницаИзмеренияНоменклатуры(СтрокаТабличнойЧасти.Номенклатура)
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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

// Процедура - обработчик события ПриИзменении поля ввода Контрагент.
//
&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)

	СтруктураДанные = ПолучитьДанныеКонтрагентПриИзменении(Объект.Контрагент, Объект.Организация);
	
	Объект.ДоговорКонтрагента = СтруктураДанные.ДоговорКонтрагента;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ФизЛицо.
//
&НаКлиенте
Процедура ФизЛицоПриИзменении(Элемент)	
	ДокументФИзЛицаНаСервере()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

// Процедура - обработчик события ПриИзменении поля ввода Номенклатура.
//
&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) И ТипЗнч(СтрокаТабличнойЧасти.Номенклатура) = ТИП("СправочникСсылка.Номенклатура") Тогда
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = ЕдиницаИзмеренияНоменклатуры(СтрокаТабличнойЧасти.Номенклатура)
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОсновныеСредства

&НаКлиенте
Процедура ОсновныеСредстваПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		СтрокаТабличнойЧасти = Элементы.ОсновныеСредства.ТекущиеДанные;
		СтрокаТабличнойЧасти.Количество = 1;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик события действия команды Подбор в табличную часть Товары.
// Открывает форму подбора.
//
&НаКлиенте
Процедура ПодборНоменклатуры(Команда)
	РаботаСПодборомНоменклатурыКлиент.ОткрытьПодбор(ЭтаФорма, "Товары", "Поступление");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Получает набор данных с сервера для процедуры КонтрагентПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеКонтрагентПриИзменении(Контрагент, Организация)
	
	ДоговорПоУмолчанию = ПолучитьДоговорПоУмолчанию(Объект.Ссылка, Контрагент, Организация);
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
		"ДоговорКонтрагента",
		ДоговорПоУмолчанию);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеКонтрагентПриИзменении()

// Получает договор по умолчанию
//
&НаСервереБезКонтекста
Функция ПолучитьДоговорПоУмолчанию(Документ, Контрагент, Организация)
	
	МенеджерСправочника = Справочники.ДоговорыКонтрагентов;
	
	СписокВидовДоговоров = МенеджерСправочника.ПолучитьСписокВидовДоговораДляДокумента(Документ);
	ДоговорПоУмолчанию = МенеджерСправочника.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговоров);
	
	Возврат ДоговорПоУмолчанию;
	
КонецФункции

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

&НаСервере
Процедура ДокументФИзЛицаНаСервере()
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(ЭтаФорма, "ДокументыФизическихЛиц", Объект.ФизЛицо);	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕдиницаИзмеренияНоменклатуры(Номенклатура)

	Возврат Номенклатура.ЕдиницаИзмерения;	

КонецФункции // ЕдиницаИзмеренияНоменклатуры(Номенклатура)()

// Процедура - обработчик подбора товаров.
//
&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресЗапасовВХранилище)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		НайденныеСтроки = Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура", СтрокаЗагрузки.Номенклатура));
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		СтрокаТабличнойЧасти = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
	КонецЦикла;
		
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

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
