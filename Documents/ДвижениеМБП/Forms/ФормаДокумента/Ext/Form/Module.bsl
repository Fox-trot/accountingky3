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
	
	ВидУчетаИзносаМБП = ПолучитьВидУчетаИзносаМБП(ДатаДокумента, Объект.Организация);
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
							 "Субконто1", "Субконто2", "Субконто3");
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл					
		БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "", "СчетЗатрат", "Товары", СтрокаТабличнойЧасти, ПоляОбъекта);
	КонецЦикла;
	
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

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СозданаРеализацияДляДвиженияМБП" Тогда 
		
		Элементы.СоздатьРеализацию.Заголовок = Параметр.Представление;
		Объект.ДокументРеализации = Параметр.Ссылка;
		ЭтотОбъект.Модифицированность = Истина;
		
	ИначеЕсли ИмяСобытия = "ПодборНоменклатурыПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьМБПИзХранилища(АдресЗапасовВХранилище);
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
							 "Субконто1", "Субконто2", "Субконто3");
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл					
		БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "", "СчетЗатрат", "Товары", СтрокаТабличнойЧасти, ПоляОбъекта);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Объект.ДокументРеализации = ВыбранноеЗначение.Ссылка;
	Элементы.СоздатьРеализацию.Заголовок = ВыбранноеЗначение.Представление;
	ЭтотОбъект.Модифицированность = Истина;
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
	
	ВидУчетаИзносаМБП = ПолучитьВидУчетаИзносаМБП(ДатаДокумента, Объект.Организация);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	ВидУчетаИзносаМБП = ПолучитьВидУчетаИзносаМБП(ДатаДокумента, Объект.Организация);
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

// Процедура - обработчик события ПриИзменении поля ввода Вид операции.
//
&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

// Процедура - обработчик события ПриИзменении поля ввода Номенклатура.
//
&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Организация", Объект.Организация);
	СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);

	// Заполнение по данным номенклатуры
	СтрокаТабличнойЧасти.СчетЗатрат = СтруктураДанные.СчетЗатрат;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СчетЗатрат.
//
&НаКлиенте
Процедура ТоварыСчетЗатратПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
								 "Субконто1", "Субконто2", "Субконто3");

	БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "", "СчетЗатрат", "Товары", СтрокаТабличнойЧасти, ПоляОбъекта);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ТоварыСубконто1.
//
&НаКлиенте
Процедура ТоварыСубконто1ПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "", "СчетЗатрат", "Товары", СтрокаТабличнойЧасти);

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ТоварыСубконто2.
//
&НаКлиенте
Процедура ТоварыСубконто2ПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "", "СчетЗатрат", "Товары", СтрокаТабличнойЧасти);

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ТоварыСубконто3.
//
&НаКлиенте
Процедура ТоварыСубконто3ПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "", "СчетЗатрат", "Товары", СтрокаТабличнойЧасти);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьРеализацию(Команда)
	СтруктураПараметров = Новый Структура;
	
	Если ЗначениеЗаполнено(Объект.ДокументРеализации) Тогда		
		СтруктураПараметров.Вставить("Ключ", Объект.ДокументРеализации);		
	Иначе
		Отказ = ПроверкаПередОткрытиемФормы();
	
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		СтруктураПараметров.Вставить("Основание", Объект.Ссылка);		
	КонецЕсли;
	                    
	ОткрытьФорму("Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента", СтруктураПараметров, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПодборЧленаКомиссии(Команда)
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("МножественныйВыбор", Истина);
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыПодбора, ЭтаФорма, УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ПодборМБП(Команда)
	Если ОткрытьПодборМБППоСкладу() Тогда
		РаботаСПодборомНоменклатурыКлиент.ОткрытьПодбор(ЭтаФорма, "Товары", "СписаниеМБПСклад");
	Иначе
		РаботаСПодборомНоменклатурыКлиент.ОткрытьПодбор(ЭтаФорма, "Товары", "СписаниеМБПМОЛ");
	КонецЕсли;
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

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

// Процедура устанавливает видимость и доступность элементов.
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()	 
	
	Элементы.ТоварыСчетЗатрат.Видимость  = Ложь;
	Элементы.ТоварыСубконто1.Видимость 	 = Ложь;
	Элементы.ТоварыСубконто2.Видимость	 = Ложь;
	Элементы.ТоварыСубконто3.Видимость 	 = Ложь;
	Элементы.Склад.Видимость 			 = Ложь;
	Элементы.ФизЛицоПолучатель.Видимость = Ложь;
	Элементы.ФизЛицо.Видимость 			 = Ложь;
	Элементы.СоздатьРеализацию.Видимость = Ложь;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию")  Тогда
		Если ВидУчетаИзносаМБП = ПредопределенноеЗначение("Перечисление.ВидыУчетаИзносаМБП.ПриВводе") Тогда
			Элементы.ТоварыСчетЗатрат.Видимость = Истина;
			Элементы.ТоварыСубконто1.Видимость  = Истина;
			Элементы.ТоварыСубконто2.Видимость  = Истина;
			Элементы.ТоварыСубконто3.Видимость  = Истина;
		КонецЕсли;
		Элементы.Склад.Видимость			 	= Истина;
		Элементы.ФизЛицоПолучатель.Видимость 	= Истина;
		
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийДвижениеМБП.СписаниеМБП") Тогда 
		Если ВидУчетаИзносаМБП = ПредопределенноеЗначение("Перечисление.ВидыУчетаИзносаМБП.ПриСписании") Тогда
			Элементы.ТоварыСчетЗатрат.Видимость = Истина;
			Элементы.ТоварыСубконто1.Видимость  = Истина;
			Элементы.ТоварыСубконто2.Видимость  = Истина;
			Элементы.ТоварыСубконто3.Видимость  = Истина;
		КонецЕсли;
		Элементы.ФизЛицо.Видимость 				= Истина;
		
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийДвижениеМБП.ПеремещениеМБП") Тогда
		Элементы.ФизЛицоПолучатель.Видимость 	= Истина;
		Элементы.ФизЛицо.Видимость 			 	= Истина;
		
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийДвижениеМБП.РеализацияМБП") Тогда
		Если ВидУчетаИзносаМБП = ПредопределенноеЗначение("Перечисление.ВидыУчетаИзносаМБП.ПриСписании") Тогда
			Элементы.ТоварыСчетЗатрат.Видимость = Истина;
			Элементы.ТоварыСубконто1.Видимость  = Истина;
			Элементы.ТоварыСубконто2.Видимость  = Истина;
			Элементы.ТоварыСубконто3.Видимость  = Истина;
		КонецЕсли;
		Элементы.ФизЛицо.Видимость 			 	= Истина;
		Элементы.СоздатьРеализацию.Видимость 	= Истина;
		
		// Задание заголовка команде "СоздатьРеализацию".
		Если ЗначениеЗаполнено(Объект.ДокументРеализации) Тогда
			Элементы.СоздатьРеализацию.Заголовок = Строка(Объект.ДокументРеализации);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()    

// Получает набор данных с сервера для процедуры НоменклатураПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	// Счета учета
	СчетаУчетаНоменклатуры = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСчетаУчетаНоменклатуры(СтруктураДанные.Организация, СтруктураДанные.Номенклатура);
	СтруктураДанные.Вставить("СчетЗатрат", СчетаУчетаНоменклатуры.СчетРасхода);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()

// Получает ВидУчетаИзносаМБП из учетной политики организации.
//
&НаСервереБезКонтекста
Функция ПолучитьВидУчетаИзносаМБП(Дата, Организация)
	ДанныеУчетнойПолитики = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиОрганизаций(Дата, Организация);
	Возврат ДанныеУчетнойПолитики.ВидУчетаИзносаМБП;
КонецФункции // ПолучитьВидУчетаИзносаМБП()

&НаСервере
Процедура ПолучитьМБПИзХранилища(АдресЗапасовВХранилище)
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

&НаСервере
Функция ОткрытьПодборМБППоСкладу()

	Возврат Объект.ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию;	

КонецФункции

&НаКлиенте
Функция ПроверкаПередОткрытиемФормы()
	Отказ = Ложь;
	
	Если Объект.ПометкаУдаления Тогда
		ТекстСообщения = НСтр("ru = 'Реализацию нельзя создать на основании документа, помеченного на удаление!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;
	
	Если ЭтаФорма.Модифицированность Тогда
		ТекстСообщения = НСтр("ru = 'Документ был изменен. Сначала следует записать документ!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстСообщения = НСтр("ru = 'Документ не записан. Сначала следует записать документ!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;	

	Возврат Отказ;	
КонецФункции

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

#Область ПроцедурыИФункцииКомиссия

// Процедура - обработчик события ПередУдалением таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияПередУдалением(Элемент, Отказ)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;
	Если ТекущаяСтрокаТЧ.Председатель Тогда
		ИндексУдаляемойСтроки = Объект.Комиссия.Индекс(ТекущаяСтрокаТЧ);
		КоличествоСтрок = Объект.Комиссия.Количество() - 1;

		Если КоличествоСтрок > 0 Тогда
			Если ИндексУдаляемойСтроки <= КоличествоСтрок - 1 Тогда
				ИндексНовогоПредседателя = ИндексУдаляемойСтроки + 1;
			Иначе
				ИндексНовогоПредседателя = КоличествоСтрок - 1;
			КонецЕсли;
			Объект.Комиссия[ИндексНовогоПредседателя].Председатель = Истина;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ПриНачалеРедактирования таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если Копирование Тогда
		ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;
		ТекущаяСтрокаТЧ.ФизЛицо = Неопределено;
		ТекущаяСтрокаТЧ.Председатель = Ложь;
	Иначе // Создание заново
		Если Объект.Комиссия.Количество() = 1 Тогда
			Объект.Комиссия[0].Председатель = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ОбработкаВыбора таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Строки = Объект.Комиссия.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение));

	Если Строки.Количество() > 0 Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Физическое лицо ""%1"" уже подобрано!'"), ВыбранноеЗначение);
		ПоказатьПредупреждение(, ТекстСообщения, 60);
	Иначе
		НоваяСтрока = Объект.Комиссия.Добавить();
		НоваяСтрока.ФизЛицо 	= ВыбранноеЗначение;		
		Если Объект.Комиссия.Количество() = 1 Тогда
			НоваяСтрока.Председатель = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Председатель.
//
&НаКлиенте
Процедура КомиссияПредседательПриИзменении(Элемент)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;

	Если НЕ ТекущаяСтрокаТЧ.Председатель Тогда
		// Снимать флажок нельзя
		ТекущаяСтрокаТЧ.Председатель = Истина;
		Возврат;
	КонецЕсли;

	Для каждого СтрокаТЧ Из Объект.Комиссия Цикл
		Если СтрокаТЧ.НомерСтроки <> ТекущаяСтрокаТЧ.НомерСтроки Тогда
			СтрокаТЧ.Председатель = Ложь;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Процедура - обработчик события ОбработкаВыбора поля ввода ФизЛицо.
//
&НаКлиенте
Процедура КомиссияФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;

	Если ТекущаяСтрокаТЧ.ФизЛицо <> ВыбранноеЗначение Тогда

		СтрокиТабличнойЧасти = Объект.Комиссия.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение));

		Если СтрокиТабличнойЧасти.Количество() > 0 Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Физическое лицо ""%1"" уже включено в состав комиссии!'"), ВыбранноеЗначение);
			ПоказатьПредупреждение(, ТекстСообщения, 60);
			СтандартнаяОбработка = Ложь;
		КонецЕсли;

	КонецЕсли;
КонецПроцедуры

#КонецОбласти
