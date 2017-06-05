﻿
#Область ОбработчикиСлужебные

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

&НаСервереБезКонтекста
Функция ПолучитьДанныеСерииСФ(Серия)
	
	СтруктураВозврата = Новый Структура("Формат, Ручные");
	ЗаполнитьЗначенияСвойств(СтруктураВозврата, Серия);
	Возврат СтруктураВозврата

КонецФункции // ПолучитьДанныеСерииСФ(Серия)

&НаКлиенте
Процедура ПересчетКоличестваБланков(СтрокаТабличнойЧасти)
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ПервыйНомер) ИЛИ НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ПоследнийНомер) Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаТабличнойЧасти.ПервыйНомер) Тогда
		ТекстСообщения = НСтр("ru = 'В номере бланка могут быть только цифры!'");
		БухгалтерскийУчетСервер.СообщитьОбОшибке(
			Объект.Ссылка,   
			ТекстСообщения,
			,
			,
			"Объект.Спецификация[" + (СтрокаТабличнойЧасти.НомерСтроки -1) + "].ПервыйНомер",
			Отказ);
	КонецЕсли;
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаТабличнойЧасти.ПоследнийНомер) Тогда
		ТекстСообщения = НСтр("ru = 'В номере бланка могут быть только цифры!'");
		БухгалтерскийУчетСервер.СообщитьОбОшибке(
			Объект.Ссылка,   
			ТекстСообщения,
			,
			,
			"Объект.Спецификация[" + (СтрокаТабличнойЧасти.НомерСтроки -1) + "].ПоследнийНомер",
			Отказ);
	КонецЕсли;
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
		
	СтрокаТабличнойЧасти.Количество = Число(СтрокаТабличнойЧасти.ПоследнийНомер) - Число(СтрокаТабличнойЧасти.ПервыйНомер) + 1;
	
КонецПроцедуры // 

#КонецОбласти

#Область УправлениеВнешнимВидом

&НаСервере
// Процедура устанавливает видимость и доступность элементов.
//
Процедура УстановитьВидимостьДоступностьЭлементов()	
	
	ИспользованиеБланковСФ 	= Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийСФ.ИспользованиеБланковСФ");
	ПеремещениеБланковСФ 	= Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийСФ.ПеремещениеБланковСФ"); 
	ПорчаБланковСФ			= Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийСФ.ПорчаБланковСФ");
	ПриходБланковСФ 		= Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийСФ.ПриходБланковСФ");
	УтеряБланковСФ 			= Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийСФ.УтеряБланковСФ");
	ХищениеБланковСФ 		= Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийСФ.ХищениеБланковСФ");

	Элементы.Выдает.Видимость = ПриходБланковСФ;
			
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()    

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступностьЭлементов()
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	Операция = Объект.Операция;
	УПП = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(ДатаДокумента, Объект.Организация);
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитовШапки

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

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетСервер.ПроверитьСуществованиеУчетнойПолитикиОрганизаций(ДатаДокумента, Объект.Организация);
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

&НаКлиенте
Процедура ОперацияПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТабличныхЧастей

&НаКлиенте
Процедура СпецификацияПервыйНомерПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Спецификация.ТекущиеДанные;
	СтрокаТабличнойЧасти.ПервыйНомер = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СтрокаТабличнойЧасти.ПервыйНомер, 6, "0");
	ПересчетКоличестваБланков(СтрокаТабличнойЧасти)
КонецПроцедуры

&НаКлиенте
Процедура СпецификацияПоследнийНомерПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Спецификация.ТекущиеДанные;
	СтрокаТабличнойЧасти.ПоследнийНомер = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СтрокаТабличнойЧасти.ПоследнийНомер, 6, "0");
	ПересчетКоличестваБланков(СтрокаТабличнойЧасти)
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если Не ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтотОбъект, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти
